From: Nik Markovic <nmarkovi.navteq@gmail.com>
Subject: Re: Strange prformance degradation when COW writes happen at fixed offsets
Date: Thu, 23 Feb 2012 20:31:02 -0600
Message-ID: <CAB3q874F+6HrjvxYduex3sKcskMYcVXOa_CqW6i1F=gDv8+u7g@mail.gmail.com>
References: <CAB3q8748dryFek4UZnh+5__feqp_ffCX-VdZNkcs62B=X47Ghw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAB3q8748dryFek4UZnh+5__feqp_ffCX-VdZNkcs62B=X47Ghw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

I noticed a few errors in the script that I used. I corrected it and
it seems that degradation is occurring even at fully random writes:


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

#build a 10GB file from a smaller download. You can tweak filesize and
the loop below for lower bandwidth
if [ ! -f $srcfile ]; then
	cd $src
	if [ ! -f $srcfile.dl ]; then
		wget http://download.thinkbroadband.com/${filesize}.zip
--output-document=$srcfile.dl
	fi
	rm -rf tarbase
	mkdir tarbase
	for  i in {1..100}; do
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
                }  else if (mode.equals("fixed")) {
                    writeOffset = i * BLOCK_SIZE;
                    offset = writeOffset; // for reporting it at the end
                } else { // mode.equals random
                    writeOffset = new
java.util.Random().nextInt(((int)f.length() - 100));
                    offset = writeOffset; // for reporting it at the end
                }
		if (writeOffset > (f.length() - 100)) {
			break;
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
cp --reflink=always $srcfile $dst/1.tst
cd $dst
for i in {1..100}; do	
	echo -n "$i."
	i_plus=`expr $i + 1`
	/usr/bin/time --format 'write: %E' java -cp $src FileTest $mode $i.tst
	/usr/bin/time --format 'cp:    %E' cp --reflink=always $i.tst $i_plus.tst
	/usr/bin/time --format 'rm:    %E' rm $i.tst
	/usr/bin/time --format 'sync:  %E' sync
	sleep 1
done
