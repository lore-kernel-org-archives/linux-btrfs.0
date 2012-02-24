From: Nik Markovic <nmarkovi.navteq@gmail.com>
Subject: Strange prformance degradation when COW writes happen at fixed offsets
Date: Thu, 23 Feb 2012 19:32:45 -0600
Message-ID: <CAB3q8748dryFek4UZnh+5__feqp_ffCX-VdZNkcs62B=X47Ghw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

My kernel version is 32-bit 3.2.0-rc5 and using btrfs-tools 0.19

I was having performance issues with BTRFS with fragmentation and
HDDs, so I decided to switch to an SSD to see if these would go away.
Performance was much better but at times, I would see a "freeze
happen" which I can't really explain. The CPU would spike up to 100%
at times.

I decided to try reproduce this, hough it may or may not be related,
while testing BTFS performance, I encountered this interesting problem
where performance would depend on whether a file is freshly copied
onto a BTRFS filesystem or obtained via COW "children". This is all
happening on a Crucial M4 SSD, so something on the SSD firmware could
be causing the issue but I feel it's related to BTRFS  metadata.

Here is the test:
1. Write a fresh large file to the file system called A
2. Make a reflink of A COW copy B
3. Modify a set of random blocks on B
4. Remove A
5. Repeat 2-5 but use newly produced B as new A

Expected results:
Each steps takes equal amount of time to complete on an SSD because
there is no fragmentation involved and the system is in the same state
at #2 because there's always only one file on the filesystem.

I used 1GB file as my source. I repeated tests using different
algorithms for the "write" in step #2 above.
Algorithm 1 (random): Write 8 bytes randomly
Algorithm 2 (fixed): Write first 8 bytes and continue at 50k offsets
Algorithm 3 (incremental): Write first 8 bytes at offset = random
(50k) then continue at 50k offsets
For each test, there were 40k writes total. Algorithm is in the Java code below.

The following is observed with each iteration ONLY when using algorithm #3
1. Over time, the time to modify the file increases
2. Over time, the time to make the reflink copy increases
3. Over time, the time to remove the file increases
4. First few writes take less then normal time to complete.

Data for 1st/5th/10th/15th/20th iteration:
Algorithm 1 and 2:
Always Write:6s
Always Copy: 0.5s
Always Remove: 0.10s

Algorithm 2:
Write: 2/6/9/10/11.5
Copy: 0.5/3/4.5/5.5/6
Remove: 0.1/1/2/2/2

As you can see, things degrade and taper off after the 10th iteration.
This probably has to do with 4k block size being near 50k/10. I don't
think this has to do with SSD garbage collection because I ran these
tests multiple times.

To use this script, cd into an empty directory on a btrfs filesystem
and and run it with "incremental" as argument. You can use other modes
to confirm expected behavior.
Script used to produce the bug:
#!/bin/bash

mode=$1
if [ -z "$mode" ]; then
	echo "Usage $0 <incremental|random|fixed>"
	exit -1
fi
mode=$1

src=`pwd`/test/src
dst=`pwd`/test/dst
srcfile=$src/test.tar
dstfile=$dst/test.tar

mkdir -p $src
mkdir -p $dst

filesize=100MB

#build a 1GB file from a smaller download. You can tweak filesize and
the loop below for lower bandwidth
if [ ! -f $srcfile ]; then
	cd $src
	if [ ! -f $srcfile.dl ]; then
		wget http://download.thinkbroadband.com/${filesize}.zip
--output-document=$srcfile.dl
	fi
	rm -rf tarbase
	mkdir tarbase
	for  i in {1..10}; do
		cp --reflink=always $srcfile.dl tarbase/$i.dl
	done
	tar -cvf $srcfile tarbase
	rm -rf tarbase
fi

cat <<END > $src/FileTest.java
import java.io.IOException;
import java.io.RandomAccessFile;
public class FileTest {
    public static final int BLOCK_SIZE = 50000;
    public static final int MAX_ITERATIONS = 40000;
    public static void main(String args[]) throws IOException {
        String mode = args[0];
        RandomAccessFile f = new RandomAccessFile(args[1], "rw");
        //int offset = 0;
        int i;
        int offset = new java.util.Random().nextInt(BLOCK_SIZE); //
initializer ONLY for incremental mode
        for (i=0; i < MAX_ITERATIONS; i++) {
            try {
                int writeOffset;
                if (mode.equals("incremental")) {
                    writeOffset = new
java.util.Random().nextInt(offset + i * BLOCK_SIZE);
                } else { // mode.equals random
                    writeOffset = new
java.util.Random().nextInt(((int)f.length() - 100));
                    offset = writeOffset; // for reporting it at the end
                }
                f.seek(writeOffset);
                f.writeBytes("DEADBEEF");
            } catch (java.io.IOException e) {
                System.out.println("EOF");
                break;
            }
        }
        System.out.print("Last offset=" + offset);
        System.out.println(". Made " + i + " random writes.");
        f.close();
    }
}

END

cd $src
javac FileTest.java


/usr/bin/time --format 'rm: %E' rm -rf $dst/*
cp --reflink=always $srcfile.dl $dst/1.tst
cd $dst
for i in {1..20}; do	
	echo -n "$i."
	i_plus=`expr $i + 1`
	/usr/bin/time --format 'write: %E' java -cp $src FileTest $mode $i.tst
	/usr/bin/time --format 'cp:    %E' cp --reflink=always $i.tst $i_plus.tst
	/usr/bin/time --format 'rm:    %E' rm $i.tst
	/usr/bin/time --format 'sync:  %E' sync
	sleep 1
done
