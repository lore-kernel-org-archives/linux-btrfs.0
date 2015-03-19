Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-09v.sys.comcast.net ([96.114.154.168]:53079 "EHLO
	resqmta-po-09v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750731AbbCSXj6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Mar 2015 19:39:58 -0400
Message-ID: <550B5C63.6010401@comcast.net>
Date: Thu, 19 Mar 2015 16:31:47 -0700
From: don fisher <hdf3@comcast.net>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: nube trying to backup my systems
Content-Type: multipart/mixed;
 boundary="------------040509040400040702030208"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040509040400040702030208
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

I am new to btrfs, being introduced under openSuse 3.2 as the root file 
system. In the past I always made backups of my disks using rsync. I now 
have two versions of the OS on the same system. I was trying to mount 
the second btrfs system as well as the first. I edited my /etc/fstab 
(attached) to add a similar set of mounts as the existing system. Man 
mount said I needed to use the subvolume ID rather than paths. So I 
mounted the root of the dest file system at /usr11, and then executed:

btrfs subvolume list -u /usr11

to obtain the UUID for each subvolume. After some time in emacs I edited 
my fstab to include IDs. It appeared successful as the output of df -a 
which follows demonstrates:

/dev/sdc2      btrfs       21G  5.9G   14G  30% /
/dev/sdc2      btrfs       21G  5.9G   14G  30% /var/tmp
/dev/sdc2      btrfs       21G  5.9G   14G  30% /var/spool
/dev/sdc3      xfs        910G  109G  801G  12% /home
/dev/sdc2      btrfs       21G  5.9G   14G  30% /var/lib/pgsql
/dev/sdc2      btrfs       21G  5.9G   14G  30% /var/opt
/dev/sdc2      btrfs       21G  5.9G   14G  30% /var/log
/dev/sdc2      btrfs       21G  5.9G   14G  30% /var/lib/named
/dev/sdc2      btrfs       21G  5.9G   14G  30% /var/lib/mailman
/dev/sdc2      btrfs       21G  5.9G   14G  30% /tmp
/dev/sdc2      btrfs       21G  5.9G   14G  30% /srv
/dev/sdc2      btrfs       21G  5.9G   14G  30% /opt
/dev/sdc2      btrfs       21G  5.9G   14G  30% /boot/grub2/x86_64-efi
/dev/sdc2      btrfs       21G  5.9G   14G  30% /var/crash
/dev/sdc2      btrfs       21G  5.9G   14G  30% /usr/local
/dev/sdc2      btrfs       21G  5.9G   14G  30% /boot/grub2/i386-pc
/dev/sdb2      btrfs       21G  9.1G   11G  47% /usr11
/dev/sdb2      btrfs       21G  9.1G   11G  47% /usr11/var/tmp
/dev/sdb2      btrfs       21G  9.1G   11G  47% /usr11/var/spool
/dev/sdb2      btrfs       21G  9.1G   11G  47% /usr11/var/opt
/dev/sdb2      btrfs       21G  9.1G   11G  47% /usr11/var/log
/dev/sdb2      btrfs       21G  9.1G   11G  47% /usr11/var/lib/pgsql
/dev/sdb2      btrfs       21G  9.1G   11G  47% /usr11/var/lib/named
/dev/sdb2      btrfs       21G  9.1G   11G  47% /usr11/var/lib/mailman
/dev/sdb2      btrfs       21G  9.1G   11G  47% /usr11/var/crash
/dev/sdb2      btrfs       21G  9.1G   11G  47% /usr11/usr/local
/dev/sdb2      btrfs       21G  9.1G   11G  47% /usr11/tmp
/dev/sdb2      btrfs       21G  9.1G   11G  47% /usr11/srv
/dev/sdb2      btrfs       21G  9.1G   11G  47% /usr11/opt
/dev/sdb2      btrfs       21G  9.1G   11G  47% /usr11/boot/grub2/x86_64-efi
/dev/sdb2      btrfs       21G  9.1G   11G  47% /usr11/boot/grub2/i386-pc

I was happy until I tried to perform an ls on /usr11/tmp and found that 
it contained the root file system, all the /usr11 files present. My plan 
had been to rsync these two systems, from / to /usr11. If I umount 
/usr1/tmp subvolume and ls on /usr1/tmp, I obtain the expected results. 
Why when I mount the subvolume do I see all of the root files? I have 
attached my fstab for reference. I hope this is an easy one.

Thanks,
Don

--------------040509040400040702030208
Content-Type: text/plain; charset=UTF-8;
 name="fstab"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="fstab"

VVVJRD0wOTRiOTA2Zi0yY2JlLTQyNDEtOGFkYy0wOTM4MjY2MDIzYWQgc3dhcCAgICAgICAg
ICAgICAgICAgc3dhcCAgICAgICBkZWZhdWx0cyAgICAgICAgICAgICAgMCAwClVVSUQ9NTIz
MmEwNzYtMTA2Mi00YjQ5LWExYzMtNDg0YTllNzg1YmFlIC8gICAgICAgICAgICAgICAgICAg
IGJ0cmZzICAgICAgZGVmYXVsdHMgICAgICAgICAgICAgIDAgMApVVUlEPTUyMzJhMDc2LTEw
NjItNGI0OS1hMWMzLTQ4NGE5ZTc4NWJhZSAvYm9vdC9ncnViMi9pMzg2LXBjICBidHJmcyAg
ICAgIHN1YnZvbD1ib290L2dydWIyL2kzODYtcGMgMCAwClVVSUQ9NTIzMmEwNzYtMTA2Mi00
YjQ5LWExYzMtNDg0YTllNzg1YmFlIC9ib290L2dydWIyL3g4Nl82NC1lZmkgYnRyZnMgICAg
c3Vidm9sPWJvb3QvZ3J1YjIveDg2XzY0LWVmaSAwIDAKVVVJRD01MjMyYTA3Ni0xMDYyLTRi
NDktYTFjMy00ODRhOWU3ODViYWUgL29wdCAgICAgICAgICAgICAgICAgYnRyZnMgICAgICBz
dWJ2b2w9b3B0ICAgICAgICAgICAgMCAwClVVSUQ9NTIzMmEwNzYtMTA2Mi00YjQ5LWExYzMt
NDg0YTllNzg1YmFlIC9zcnYgICAgICAgICAgICAgICAgIGJ0cmZzICAgICAgc3Vidm9sPXNy
diAgICAgICAgICAgIDAgMApVVUlEPTUyMzJhMDc2LTEwNjItNGI0OS1hMWMzLTQ4NGE5ZTc4
NWJhZSAvdG1wICAgICAgICAgICAgICAgICBidHJmcyAgICAgIHN1YnZvbD10bXAgICAgICAg
ICAgICAwIDAKVVVJRD01MjMyYTA3Ni0xMDYyLTRiNDktYTFjMy00ODRhOWU3ODViYWUgL3Vz
ci9sb2NhbCAgICAgICAgICAgYnRyZnMgICAgICBzdWJ2b2w9dXNyL2xvY2FsICAgICAgMCAw
ClVVSUQ9NTIzMmEwNzYtMTA2Mi00YjQ5LWExYzMtNDg0YTllNzg1YmFlIC92YXIvY3Jhc2gg
ICAgICAgICAgIGJ0cmZzICAgICAgc3Vidm9sPXZhci9jcmFzaCAgICAgIDAgMApVVUlEPTUy
MzJhMDc2LTEwNjItNGI0OS1hMWMzLTQ4NGE5ZTc4NWJhZSAvdmFyL2xpYi9tYWlsbWFuICAg
ICBidHJmcyAgICAgIHN1YnZvbD12YXIvbGliL21haWxtYW4gMCAwClVVSUQ9NTIzMmEwNzYt
MTA2Mi00YjQ5LWExYzMtNDg0YTllNzg1YmFlIC92YXIvbGliL25hbWVkICAgICAgIGJ0cmZz
ICAgICAgc3Vidm9sPXZhci9saWIvbmFtZWQgIDAgMApVVUlEPTUyMzJhMDc2LTEwNjItNGI0
OS1hMWMzLTQ4NGE5ZTc4NWJhZSAvdmFyL2xpYi9wZ3NxbCAgICAgICBidHJmcyAgICAgIHN1
YnZvbD12YXIvbGliL3Bnc3FsICAwIDAKVVVJRD01MjMyYTA3Ni0xMDYyLTRiNDktYTFjMy00
ODRhOWU3ODViYWUgL3Zhci9sb2cgICAgICAgICAgICAgYnRyZnMgICAgICBzdWJ2b2w9dmFy
L2xvZyAgICAgICAgMCAwClVVSUQ9NTIzMmEwNzYtMTA2Mi00YjQ5LWExYzMtNDg0YTllNzg1
YmFlIC92YXIvb3B0ICAgICAgICAgICAgIGJ0cmZzICAgICAgc3Vidm9sPXZhci9vcHQgICAg
ICAgIDAgMApVVUlEPTUyMzJhMDc2LTEwNjItNGI0OS1hMWMzLTQ4NGE5ZTc4NWJhZSAvdmFy
L3Nwb29sICAgICAgICAgICBidHJmcyAgICAgIHN1YnZvbD12YXIvc3Bvb2wgICAgICAwIDAK
VVVJRD01MjMyYTA3Ni0xMDYyLTRiNDktYTFjMy00ODRhOWU3ODViYWUgL3Zhci90bXAgICAg
ICAgICAgICAgYnRyZnMgICAgICBzdWJ2b2w9dmFyL3RtcCAgICAgICAgMCAwClVVSUQ9Y2U3
ZDQ4YTktYzNmNi00YTIzLTgwMDQtNTIwOGI4Mjc2Zjg1IC9ob21lICAgICAgICAgICAgICAg
IHhmcyAgICAgICAgZGVmYXVsdHMgICAgICAgICAgICAgIDEgMgoKIyBVVUlEIGZvciBzdWJ2
b2x1bWVzIGNhbWUgZnJvbSBidHJmcyBzdWJ2b2x1bWUgbGlzdCAtdSAvdXNyMTEgdXNlIGRm
IC1hCiNVVUlEPTBhZjk2OGM0LWZiYjUtNGNkZS1iNWI4LTE4MTc2MzE3MGEzNCBzd2FwIAkg
ICAgICAgc3dhcCAJICBkZWZhdWx0cyAJCTAgMApVVUlEPTI2ZDYzZDk5LTkyZjQtNGE0OS04
NzhiLTIzNmY1ZTg4YWY2OSAvdXNyMTEgCSAgICAgICBidHJmcyAJICBkZWZhdWx0cyAJCTAg
MApVVUlEPTI2ZDYzZDk5LTkyZjQtNGE0OS04NzhiLTIzNmY1ZTg4YWY2OSAvdXNyMTEvYm9v
dC9ncnViMi9pMzg2LXBjIGJ0cmZzIHN1YnZvbGlkPVVVSUQ9YjYyY2ZmZTUtMzJkYy1hNDRm
LTkxMTctZWQxNTU4ZmVhYzgzICAgICAgMCAwClVVSUQ9MjZkNjNkOTktOTJmNC00YTQ5LTg3
OGItMjM2ZjVlODhhZjY5IC91c3IxMS9ib290L2dydWIyL3g4Nl82NC1lZmkgYnRyZnMgc3Vi
dm9saWQ9VVVJRD1kZjQ0Yjg0Ny04MWFlLWE0NDctOWNiMS0yZTAxNTI2MjEyNWYgMCAwClVV
SUQ9MjZkNjNkOTktOTJmNC00YTQ5LTg3OGItMjM2ZjVlODhhZjY5IC91c3IxMS9vcHQgCQli
dHJmcyAgCSAgc3Vidm9saWQ9VVVJRD0zYzQ2ZWM2Ny00NDJiLWE1NDYtODM5Ni0wZTM0Y2Uy
Y2Q0OTMgCTAgMApVVUlEPTI2ZDYzZDk5LTkyZjQtNGE0OS04NzhiLTIzNmY1ZTg4YWY2OSAv
dXNyMTEvc3J2IAkJYnRyZnMgCSAgc3Vidm9saWQ9VVVJRD1kYzcxMGFlZC00NzMxLWJhNGYt
YWNjMC04ZjQzZTcxMDIyOGEgCTAgMApVVUlEPTI2ZDYzZDk5LTkyZjQtNGE0OS04NzhiLTIz
NmY1ZTg4YWY2OSAvdXNyMTEvdG1wIAkJYnRyZnMgCSAgc3Vidm9saWQ9VVVJRD1kMzA4MGE3
YS1iNzRjLWIxNDUtYTVkYy1mY2Y4MGFlYmRhOGQJMCAwClVVSUQ9MjZkNjNkOTktOTJmNC00
YTQ5LTg3OGItMjM2ZjVlODhhZjY5IC91c3IxMS91c3IvbG9jYWwgCWJ0cmZzIAkgIHN1YnZv
bGlkPVVVSUQ9Y2FiNmJjMjUtZGI3Yy01MDQ2LTgyODUtN2ZiNGUxNzg4NmM5IAkwIDAKVVVJ
RD0yNmQ2M2Q5OS05MmY0LTRhNDktODc4Yi0yMzZmNWU4OGFmNjkgL3VzcjExL3Zhci9jcmFz
aCAJYnRyZnMgCSAgc3Vidm9saWQ9VVVJRD04NTAxNDZlMS04Y2M4LWQ4NGEtODg5NS0yNmU0
YmRiZjZkNjMgCTAgMApVVUlEPTI2ZDYzZDk5LTkyZjQtNGE0OS04NzhiLTIzNmY1ZTg4YWY2
OSAvdXNyMTEvdmFyL2xpYi9tYWlsbWFuIGJ0cmZzIAkgIHN1YnZvbGlkPVVVSUQ9NDRlNGU5
ZjEtMDMwZC1jODQ2LTgzY2ItNDg5N2JmYjNjNzdmIAkwIDAKVVVJRD0yNmQ2M2Q5OS05MmY0
LTRhNDktODc4Yi0yMzZmNWU4OGFmNjkgL3VzcjExL3Zhci9saWIvbmFtZWQgCWJ0cmZzIAkg
IHN1YnZvbGlkPVVVSUQ9ODE4ZWQyZTktMjRmOC0zZDQ1LWJjNzUtZjM1NmEzNzE2N2ZlIAkw
IDAKVVVJRD0yNmQ2M2Q5OS05MmY0LTRhNDktODc4Yi0yMzZmNWU4OGFmNjkgL3VzcjExL3Zh
ci9saWIvcGdzcWwgCWJ0cmZzIAkgIHN1YnZvbGlkPVVVSUQ9ZjI1ZGUwNTMtZjI2OC0xMTQx
LTkxMzEtNjA1ZmRlMGI5ZDBkIAkwIDAKVVVJRD0yNmQ2M2Q5OS05MmY0LTRhNDktODc4Yi0y
MzZmNWU4OGFmNjkgL3VzcjExL3Zhci9sb2cgCWJ0cmZzIAkgIHN1YnZvbGlkPVVVSUQ9MzM5
MTBjNGEtODhmNS00NjQ0LWE2N2EtN2UyMWYzYjFlZjY3IAkwIDAKVVVJRD0yNmQ2M2Q5OS05
MmY0LTRhNDktODc4Yi0yMzZmNWU4OGFmNjkgL3VzcjExL3Zhci9vcHQgCWJ0cmZzIAkgIHN1
YnZvbGlkPVVVSUQ9OWQyZGFjYmQtODhhZS1iMjQ5LWEyYzYtYzY1NDVkMTA3YTY4IAkwIDAK
VVVJRD0yNmQ2M2Q5OS05MmY0LTRhNDktODc4Yi0yMzZmNWU4OGFmNjkgL3VzcjExL3Zhci9z
cG9vbAlidHJmcyAJICBzdWJ2b2xpZD1VVUlEPTVjOTk2ZGZkLWJjM2EtMzE0YS1hNjllLWE0
M2Y1M2JkZTk0OCAJMCAwClVVSUQ9MjZkNjNkOTktOTJmNC00YTQ5LTg3OGItMjM2ZjVlODhh
ZjY5IC91c3IxMS92YXIvdG1wIAlidHJmcyAJICBzdWJ2b2xpZD1VVUlEPTIxMTkwY2RmLTk3
MzYtZWE0Yi1hYmYwLWQ1ZTkzOTExODkxYiAJMCAwCiNVVUlEPTdmMmJjMjhhLTFjNjktNDlm
Yi1iNGE4LWQ0ZWVjNzlkMmZhNSAvaG9tZSAJCXhmcyAJICBkZWZhdWx0cyAJCTEgMgojVVVJ
RD0yNmQ2M2Q5OS05MmY0LTRhNDktODc4Yi0yMzZmNWU4OGFmNjkgLy5zbmFwc2hvdHMgCQli
dHJmcyBzCSAgdWJ2b2w9LnNuYXBzaG90cyAJMCAwCgojL2Rldi9zcjAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgL2Nkcm9tICAgICAgICBhdXRvICAgIHVzZXJzLGV4ZWMs
ZGV2LHN1aWQscncsYXN5bmMsbm9hdXRvICAgICAwICAgICAgIDAKIy9kZXYvc2RkMSAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIC91c3IxMSAgICAgICAgYXV0byAgICB1c2Vy
cyxleGVjLGRldixzdWlkLHJ3LGFzeW5jLG5vYXV0byAgICAgMCAgICAgICAwCg==
--------------040509040400040702030208--
