From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: how can I copy files bigger than ~32 GB when using compress-force?
Date: Tue, 12 Oct 2010 17:01:11 +0200
Message-ID: <4CB47837.6090407@wpkg.org>
References: <4CAA4A34.80701@wpkg.org> <20101004222837.GD9759@think> <4CB442A5.20406@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4CB442A5.20406@wpkg.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 12.10.2010 13:12, Tomasz Chmielewski wrote:
> On 05.10.2010 00:28, Chris Mason wrote:
>
>>>> Does it happen with any 32gb file that doesn't compress well?
>>>
>>> The 220 GB qcow2 file was basically uncompressible (backuppc archive
>>> full of bzip2-compressed files).
>>
>> Ok, I think I know what is happening here, they all lead to the same
>> chunk of code.  I'll be able to reproduce this locally.
>
> FYI, qemu/kvm doesn't seem to like its files located on btrfs mounted with compress-force.
>
> I have a filesystem mounted with noatime,compress-force, where I created a 100GB sparse file.
> There, I wanted to install a Linux distribution - however, the whole qemu-kvm process hanged with these entries being repeated over and over.
> It's not possible to kill the qemu-kvm process (even with kill -9) etc.
>
>
> [103678.068429] INFO: task qemu-kvm:18722 blocked for more than 120 seconds.

Hmm, I see it blocks infinitely like this whether qemu-kvm tries to 
access a sparse file mounted with compress, compress-force, or no 
compression at all.

Also hangs with non-sparse files mounted without compression (didn't try 
with compression).

So must be some other bug.


And, I see occasional:

bad ordered accounting left 4096 size 12288

when it happens.


-- 
Tomasz Chmielewski
http://wpkg.org
