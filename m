From: dima <dolenin@parallels.com>
Subject: Re: linux v3.1 with btrfs-work: oops when deleting files
Date: Thu, 27 Oct 2011 10:15:54 +0900
Message-ID: <4EA8B0CA.4020206@parallels.com>
References: <6mrhn8-b6u.ln1@hurikhan.ath.cx> <4EA7D478.8030106@parallels.com> <CAMthOuNq2E+sQxmkTBHUbiPyPCthVKsSaZTo1hVV1rgOb9NJqQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Cc: <linux-btrfs@vger.kernel.org>
To: Kai Krakow <hurikhan77+btrfs@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAMthOuNq2E+sQxmkTBHUbiPyPCthVKsSaZTo1hVV1rgOb9NJqQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 10/27/2011 02:40 AM, Kai Krakow wrote:
>>> I'm trying to rm some files, this is what I get in dmesg:
> [snip]
>>
>> Can you ls the directory where the problem files are located? What would the
>> the output? I had a very similar problem but on 3.0.x kernel when several
>> files suddenly got corrupted.
>
> I can run "find -type f" for directories I suspect corrupted files in,
> and I see errors in dmesg if it happens to contain bad files. But no
> oopses and the system remains stable. If I mount the filesystem
> read-only I can even read these files without oopses, this way I
> produced an rsync backup to my original partition I created the btrfs
> subvolume from.

I see. Just to share my experience. I think I had a different case 
because I could not even read some 20-30 files (photos) on my /home 
subvolume and any attempt to access them via rm or ls would give me 
kernel oopses, though the system would not crash with 3.1 kernel.
Unless I tried to access the corrupted files the filesystem was stable 
and my / subvolume was fine. So I backed up everything not-corrupted (I 
did have the backups for the corrupted files anyway) and created my 
/home subvolume anew. I deleted the old subvolume and most of the space 
was reclaimed.

But btrfsck would still give me errors about inability to access some 
inode (
