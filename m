From: C Anthony Risinger <anthony@extof.me>
Subject: Scary OOPS when playing with --bind, --move, and friends
Date: Mon, 20 Dec 2010 21:51:40 -0600
Message-ID: <AANLkTikwFUOUE4i3Whyh2_jfH+fPdK3GYL09vCqmuCod@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

hello,

i really need to stop recklessly doing this stuff to my laptop... i'm
finishing a new initramfs hook to support many features of btrfs; when
considering how i was going to mount the target subvol as / for the
booting system, i decided to play with --bind and --move.

in short, everything works fine until you --bind across a subvol via
the "special" folders created when one takes a snapshot, or --bind the
special folder itself.  the --bind succeeds, and everything initially
appears to work fine...

this is nearly the exact process i did; should reproduce :-(i'm scared
to do it again...):

-----------------------------------------------------
# mkdir -p sand/root sand/bind
# cd sand
# mount -o subvolid=0 /dev/sda root
# mount --bind root/<subvol of my current root>/home/anthony bind
# touch bind/TEST

<you can now see TEST at ~/TEST and bind/TEST>

# vim bind/TEST
  did it work?
:wq

<you can see the edited version ONLY in the one you edited... the
other is still 0 bytes>

# vim ~/anthony/TEST
1 wtf, why not?
:wq

<machine panics, X is instantly replaced by an oopsie screen; machine locked>
-----------------------------------------------------

i don't know why i decided to stupidly edit the bad version, even
though something was clearly wrong.  at any rate, this was about 15
minutes ago... the machine booted back up alright after a hard reboot,
hooray for that, but methinks there is probably some corruptions in
there now... meh.

i don't know what it means, but when the two versions desynced (it
could have been like this, but i didn't notice until after the
desync), `ls -l` reported a `0` right after the permissions:

....
-rw-r--r-- 0 anthony users 8 Dec 20 21:41 TEST
....

all other files report `1`.  since /dev and /proc etc. have different
numbers, this appears to have something to do with the mount or
device?

i panicked wen the kernel did, and i forgot to write down the message,
but the trace had `vfs_rename` and `tomoyo_???`... sorry for the bad
memory.  vim was attempting to move a temporary file over the top of
the misbehaving file, hence the rename.

i'm on 2.6.36.2

the `directory as a subvol` thing seems to be a little finicky :-) did
i do something incorrect?  should this kind of operation be supported?
 it seems to work fine so long as i stay on the same subvol.

thanks,

C Anthony
