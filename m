From: Hadmut Danisch <hadmut@danisch.de>
Subject: Re: Setting options permanently?
Date: Sat, 28 Jan 2012 01:49:26 +0100
Message-ID: <4F234616.6020407@danisch.de>
References: <4F22BCCC.5090800@danisch.de> <CAAE6i0gSG4xuyJFQrmfFNh3ojF4GBbsgk7LsN+1XD=9Mp5rSUQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Cc: linux-btrfs@vger.kernel.org
To: Chester <somethingsome2000@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAAE6i0gSG4xuyJFQrmfFNh3ojF4GBbsgk7LsN+1XD=9Mp5rSUQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Am 28.01.2012 00:20, schrieb Chester:
> It should be okay to mount with compress or without compress. Even if
> you mount a volume with compressed data without '-o compress' you wil=
l
> still be able to correctly read the data (but newly written data will
> not be compressed)

But having both compressed and uncompressed files in the filesystem is
exactly what I want to avoid. Not because of reading problems, but to
avoid wasting disk space. I don't have a reading problem. I have a
writing problem.

I want to pack some data onto USB hard disks, which exceed the plain
disk capacity. With btrfs it works exactly the way as I need it, except
for the fact that once the compress option was missed the file system i=
s
=84tainted=94 with uncompressed files, thus wasting disk capacity and m=
aybe
cause the files to not fit on the disk anymore.

I currently don't see how to repair this afterwards without removing th=
e
uncompressed files and writing new ones, which on the other hand spoils
hte memory saving effect of using snapshots instead of copies.


It would be much better if there was a way to set options like the
compression option permanently when initially creating the file system,
or later with the btrfs tools.



regards
Hadmut

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
