From: Leho Kraav <leho@kraav.com>
Subject: btrfs 3.2.2 -> 3.3.1 upgrade finally ate babies, some advice?
Date: Mon, 09 Apr 2012 16:24:33 +0300
Message-ID: <4F82E311.1040905@kraav.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi all

$ uname -a
Gentoo Linux s9 3.3.1-pf #2 SMP PREEMPT Mon Apr 9 00:35:28 EEST 2012 
i686 Intel(R) Core(TM) i5-2467M CPU @ 1.60GHz GenuineIntel GNU/Linux

I was running stuff for the past year or so on 4 partitions:

/dev/sda1 -> dm-crypt -> btrfs raid 0 ROOT 10.0GB
/dev/sda2 -> dm-crypt -> btrfs raid 0 ROOT 10.0GB
/dev/sda3 -> dm-crypt -> btrfs raid 0 HOME 10.0GB
/dev/sda4 -> dm-crypt -> btrfs raid 0 HOME 10.0GB

Both filesystems mounted with "noatime,nodiratime,ssd,discard,compress=lzo"

I set that multi-partition monster up back in the 2.6.36ish days, when 
dm-crypt either was not capable of utilizing multicores on a single 
partition or I possibly didn't know that it already could. At one point 
it definitely couldn't.

So over time HOME started filling up and at the point of last night's 
baby eating "df -hT" showed 1.7G free. Yes I know free space is 
complicated in btrfs. Space had not been an issue so I didn't think to 
use any better tools regularly to check, such as "btrfs fi show" I guess.

I upgraded my 3.2.2-pf to 3.3.1-pf* and proceeding to launching my 
regular apps Firefox, TB, office, etc. Except they all hung. Checking my 
/var/log/message window revealed what was happening:

* pf-sources => http://pf.natalenko.name/

...
Apr  8 02:45:52 s9 sudo:     leho : TTY=pts/0 ; PWD=/home/leho ; 
USER=root ; COMMAND=/bin/tail -
f /home/leho/.tail/awesome-leho /home/leho/.tail/messages 
/home/leho/.tail/openvpn.log
Apr  8 02:45:52 s9 sudo: pam_unix(sudo:session): session opened for user 
root by (uid=0)
Apr  8 02:46:11 s9 kernel: [  189.691778] attempt to access beyond end 
of device
Apr  8 02:46:11 s9 kernel: [  189.691787] dm-3: rw=129, want=23361976, 
limit=20967424
Apr  8 02:46:11 s9 kernel: [  189.691792] attempt to access beyond end 
of device
Apr  8 02:46:11 s9 kernel: [  189.691795] dm-3: rw=129, want=27556216, 
limit=20967424
Apr  8 02:46:11 s9 kernel: [  189.691799] attempt to access beyond end 
of device
...
Apr  8 02:46:11 s9 kernel: [  189.691869] attempt to access beyond end 
of device
Apr  8 02:46:11 s9 kernel: [  189.691874] dm-3: rw=129, want=69498616, 
limit=20967424
...
Apr  8 02:46:11 s9 kernel: [  189.692233] attempt to access beyond end 
of device
Apr  8 02:46:11 s9 kernel: [  189.692237] dm-3: rw=129, want=228879736, 
limit=20967424
(thousands of lines of this, as we can see "want" gets bigger all the time)

And it was all downhill from there. Result is a majorly corrupted 
filesystem that seems to be beyond repair. Hard rebooting back started 
giving csum errors in various spots and any modifications to the 
filesystem, even deleting files, would start another flood of "attempt 
to access beyond end of device", totally messing up syslog-ng. With 
blazing speedsc of an SSD that probably isn't a surprise.

So searching around, I found out about the ENOSPC thing which is 
possibly still an issue in 3.3. Is there any useful info I could provide 
for this? I now have some bigger partitions and probably won't run out 
of space again for a while.

I also discovered the btrfs "restore" binary, although possibly it was 
too late, since I had already hard rebooted a few times and done some 
more damage to HOME. This thing returned a whole bunch of "ret is -3" 
messages, and 0 byte files. Occasionally files were good as well. But 
majority of the files, seems to corrupt. When running out of space 
happens, is this a reasonable result to expect?

"btrfs scrub" reported uncorrectable errors count in the millions. At 
least thousands of csum mismatch errors visible in dmesg.

"btrfs balance" would bomb the machine with the same "access beyond end 
of device".

I made images of the two btrfs partitions on sda3 and sda4 for future 
diagnosis. I do think they are pretty corrupt though. Or could there be 
some magic poke or offset that would make more stuff magically 
"restore"-able :>

So in conclusion:

  * is filesystem-wide corruption like this helped by running on top of 
dm-crypt or btrfs multi device? dm-crypt is definitely staying for me, 
but I did consolidate partitions now to just 2.
  * what exactly should happen when an out of space scenario like the 
above happens?
  * I guess I should keep an eye on "btrfs fi show" on the regular?
