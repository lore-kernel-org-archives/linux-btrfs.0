Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:42939 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759830Ab3BZVQ6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Feb 2013 16:16:58 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: kreijack@inwind.it
Subject: Re: [PATCH, RFC] btrfs-progs: require mkfs -f force option to overwrite filesystem or partition table
Date: Tue, 26 Feb 2013 22:16:55 +0100
Cc: linux-btrfs@vger.kernel.org, Tsutomu Itoh <t-itoh@jp.fujitsu.com>,
        Eric Sandeen <sandeen@redhat.com>, chris.mason@fusionio.com,
        Stefan Behrens <sbehrens@giantdisaster.de>,
        David Sterba <dsterba@suse.cz>
References: <511D2D2B.8040804@redhat.com> <201302261137.46319.Martin@lichtvoll.de> <512D092F.5040003@gmail.com> (sfid-20130226_220055_922165_4972CB32)
In-Reply-To: <512D092F.5040003@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201302262216.56187.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Dienstag, 26. Februar 2013 schrieb Goffredo Baroncelli:
> > And I teach not to in my trainings as well.
> >
> > 
> >
> > Everyone who uses rm -rf by default even just for deleting a single
> > file does  it as long as he or she deleted his / her home directory or
> > something.
> 
> Unfortunately the "rm -rf" is a different case. Removing a directory is
> a common case. We should not be forced to use the -f for common case. A
> '-f' flag should be used only in "uncommon" case (like *re*format a disk
> or a test-suite)...
> 
> However I think that '-f' is good for mkfs.btrfs.

I don´t get you on this one:

artin@merkaba:~/Zeit> export LANG=C
martin@merkaba:~/Zeit> mkdir test
martin@merkaba:~/Zeit> rm test
rm: cannot remove 'test': Is a directory
martin@merkaba:~/Zeit#1> rm -f test
rm: cannot remove 'test': Is a directory
martin@merkaba:~/Zeit#1> rm -r test
martin@merkaba:~/Zeit> mkdir test
martin@merkaba:~/Zeit> rmdir test
martin@merkaba:~/Zeit>

So you do not need -f to remove a directory, but either rm -r or rmdir (if 
its empty).

I think that special casing deleting empty directories with rmdir command 
doesn´t make much sense. The most important distinction there IMHO is to 
recurse or not to recurse. Thus I would let rm also delete empty directories 
and remove rmdir altogether or alias it to rm (without -r!). Thats how it 
was done on AmigaOS delete command. Delete would delete files and empty 
dirs, and recurse only if ALL option was given.

rm -f doesn´t work anyway if parent directory has write permission removed:

martin@merkaba:~/Zeit> mkdir -p test/test
martin@merkaba:~/Zeit> chmod a-w test
martin@merkaba:~/Zeit> cd test
martin@merkaba:~/Zeit> rm -r test
rm: descend into write-protected directory 'test'? y
rm: cannot remove 'test/test': Permission denied
martin@merkaba:~/Zeit> rm -rf test
rm: cannot remove 'test/test': Permission denied

       -f, --force
              ignore nonexistent files and arguments, never prompt



Only in the case the directory itself is write-protected rm -f makes the 
prompt go away:

martin@merkaba:~/Zeit> mkdir test
martin@merkaba:~/Zeit> chmod a-w test
martin@merkaba:~/Zeit> rm -r test
rm: remove write-protected directory 'test'? y
martin@merkaba:~/Zeit> mkdir -m a-w test
martin@merkaba:~/Zeit> ls -ld test
dr-xr-xr-x 1 martin martin 0 Feb 26 22:12 test
martin@merkaba:~/Zeit> rm -rf test

But on skipping write protection -f is justified I think.

But more so since this is a empty directory and the parent directory has 
write protection, rmdir will remove it without -f (which it doesn´t support 
anyway):

martin@merkaba:~/Zeit> mkdir -m a-w test
martin@merkaba:~/Zeit> rmdir test
martin@merkaba:~/Zeit> 

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
