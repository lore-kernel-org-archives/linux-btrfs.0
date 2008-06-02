From: Joe Peterson <lavajoe@gentoo.org>
Subject: 'cp -p' leaves mode on destination files/dirs incorrect
Date: Mon, 02 Jun 2008 17:42:50 -0600
Message-ID: <4844857A.4010708@gentoo.org>
References: <200805291148.46203.chris.mason@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200805291148.46203.chris.mason@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi all, this is a problem observed in btrfs-0.15:

Using 'cp -p', 'cp -a', or moving files to btrfs from another filesystem
(which does a copy then remove) will leave the copied files with the
wrong mode.  Specifically, all permissions for 'group' or 'other' are
nulled out.  My umask is the typical 0022, but umask should not matter
here anyway (to make sure I wasn't crazy, I tried it on an ext3 partition).

The simplest example is:

touch bar
cp -p bar foo

Doing 'ls -l bar foo' yields:

-rw-r--r-- 1 joe skyrush 0 Jun  2 17:38 bar
-rw------- 1 joe skyrush 0 Jun  2 17:38 foo

For directories, if they used to have mode 755, the copies will then
have mode 700.

I first noticed this when moving dirs from another partition, but
'cp -a', of course, demonstrated it as well.

I do not know the btrfs code well yet, but I am willing to help
investigate this, especially of someone points me to the right place to
start looking.  :)

						-Thanks, Joe
