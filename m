From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: linux v3.1 with btrfs-work: oops when deleting files
Date: 26 Oct 2011 20:52:00 +0200
Message-ID: <Bwa12Zyi1uB@helmut.hullen.de>
References: <CAMthOuNq2E+sQxmkTBHUbiPyPCthVKsSaZTo1hVV1rgOb9NJqQ@mail.gmail.com>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAMthOuNq2E+sQxmkTBHUbiPyPCthVKsSaZTo1hVV1rgOb9NJqQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Kai,

Du meintest am 26.10.11:

> I can run "find -type f" for directories I suspect corrupted files
> in, and I see errors in dmesg if it happens to contain bad files. But
> no oopses and the system remains stable. If I mount the filesystem
> read-only I can even read these files without oopses,

Ok - may be I need this hint too sometimes in the next weeks.

> But since I do not have enough capacity to hold both my original
> backup (home files only, the system is already outdated) and the
> complete btrfs system (combined multiple partitions from an lvm setup
> into one btrfs volume with subvolumes) I cannot just recreate the
> same file system from scratch. Looks like I have to buy another hard
> disk (going to become expensive soon anyway) and rsync over to a
> fresh btrfs.

Same problem here. I fear that I have to copy my btrfs cluster (more  
than 4 TByte on 3 disks) to another 3-disk cluster - last week that  
would have been 200 Euro, now it may be 300 Euro.

I don't dare the way

        add a 4th 2-TByte disk
        balance
        remove the bad disk

(that was the major reason for me using btrfs - adding bigger disks,  
removing smaller disks ...)

Viele Gruesse!
Helmut
