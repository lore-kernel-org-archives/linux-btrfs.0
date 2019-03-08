Return-Path: <SRS0=LIGD=RL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56BB1C43381
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Mar 2019 12:20:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0FF9C20811
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Mar 2019 12:20:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KTgNKfUg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726388AbfCHMUL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 8 Mar 2019 07:20:11 -0500
Received: from mail-io1-f52.google.com ([209.85.166.52]:33277 "EHLO
        mail-io1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726042AbfCHMUK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Mar 2019 07:20:10 -0500
Received: by mail-io1-f52.google.com with SMTP id b6so3025530iog.0
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Mar 2019 04:20:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QE+t/e2zxvWDEEcbb1nJS+4IPRbOWEVOnKNatf0cS54=;
        b=KTgNKfUgRvR6oX9FLSqtb7Sv+ugXP9panoI/Jtjn86UYGxzwGEc+3yTQgLEPbQ8SM/
         giKGN/hCXtYF45B9YEgvkL5ed9x0tARnPCV6Dmo3W71OsLroxUuDdbQrW4oDaEQ5xjQX
         XAZenisSxfzKzNDJIyXcD4Z+o5oMO1RJ7tWyeCrRP163cF/xKMaNmN/LBA+w4Hbkaa1J
         BD2Kp82pGXWHGXUaJA4WFg0M+Hg8rf0j97satn7uDpbUeN1TGch48JOxJPm98U1SnNkz
         PdD7op1bS1S3ybIGx/e8lbzrfNIe1AaDOzhEYX+EA9beojFtv9aXnudcz/kx2FpI+dnf
         R2Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QE+t/e2zxvWDEEcbb1nJS+4IPRbOWEVOnKNatf0cS54=;
        b=P1INdBtMAw+VPTVJlBarvYvnfRsm+lJsFo9siYa68onczT6wOcFNp2mbk+U6mMSqEV
         Vj2ZgOoe57s8uiBM22OyufBxVKAGa4EDU9OA14c81stLUyDOCwantCd8/VPtV19BEYZV
         SL05wzYIIRoZCfiurnWH6DCcpN9MDdGVh//oAzViv0l0xahMcabsignWiyNFykmCip1U
         lrkKc6IJMhDyNkaAz0BPbiagGL+IQmam1Q66xjHB5NkXtqo1A4ANs5jZ5y6VPYnUFw0s
         +h8rrvlLnmGNDlZywe5WSpCqTsG9QfZnxSdrexLFt558bFpw+nCmL9FDMhS7yk258cVP
         Ex1A==
X-Gm-Message-State: APjAAAViTw90ATHGlrvPIO2QrUpyUQJwKRlum+tseAlKv/S6duXYgxh8
        IgDFsY1+yFbSRlGTbjYf4nClVgdFB0o=
X-Google-Smtp-Source: APXvYqzAzN/KrkRbj7EwJNdbuLaEaQAJnKtX/nKa02d79eL6ek0vhtFGhc62kjgWZhy5+FVRDYJetg==
X-Received: by 2002:a5d:9806:: with SMTP id a6mr3192366iol.296.1552047609115;
        Fri, 08 Mar 2019 04:20:09 -0800 (PST)
Received: from [191.9.209.46] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id j143sm3953892itj.16.2019.03.08.04.20.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Mar 2019 04:20:08 -0800 (PST)
Subject: Re: Reproducer for "compressed data + hole data corruption bug, 2018
 edition" still works on 4.20.7
To:     Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        Christoph Anton Mitterer <calestyo@scientia.net>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
References: <CAL3q7H7T_NX=D8qimRC55g8V-p0k-ygUiW-K5bxF02r-6XT6Rg@mail.gmail.com>
 <20190212165916.GA23918@hungrycats.org>
 <CAL3q7H6eTTw-iTHiQLcJHa5iRRspWxQpfyTQRU1SmcxBqXSppg@mail.gmail.com>
 <20190212181328.GB23918@hungrycats.org>
 <CAL3q7H4k=N=0Cv8hYAZkfTfaG8XJgG1KzT5mA_4XnutxGFc8DA@mail.gmail.com>
 <CAL3q7H6YShEBKDTDZ7_qBoLDMgihP_8NYee_60-LUqd6sF5xZQ@mail.gmail.com>
 <CAL3q7H6WSe_C7_+D0x1_Z+KdK=k+iM-t2J4pQSO32ZsY4AEZ=Q@mail.gmail.com>
 <95e4d9825c2565473184765c4d77ae0015d01580.camel@scientia.net>
 <20190215054031.GC9995@hungrycats.org>
 <f9fddae4bc3d59e539b7bc56ae75a5f04a165682.camel@scientia.net>
 <20190307200712.GG23918@hungrycats.org>
From:   "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <b701dc28-a703-7e7c-2ced-aad07e70850a@gmail.com>
Date:   Fri, 8 Mar 2019 07:20:04 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <20190307200712.GG23918@hungrycats.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2019-03-07 15:07, Zygo Blaxell wrote:
> On Mon, Mar 04, 2019 at 04:34:39PM +0100, Christoph Anton Mitterer wrote:
>> Hey.
>>
>>
>> Thanks for your elaborate explanations :-)
>>
>>
>> On Fri, 2019-02-15 at 00:40 -0500, Zygo Blaxell wrote:
>>> The problem occurs only on reads.  Data that is written to disk will
>>> be OK, and can be read correctly by a fixed kernel.
>>>
>>> A kernel without the fix will give corrupt data on reads with no
>>> indication of corruption other than the changes to the data itself.
>>>
>>> Applications that copy data may read corrupted data and write it back
>>> to the filesystem.  This will make the corruption permanent in the
>>> copied data.
>>
>> So that basically means even a cp (without refcopy) or a btrfs
>> send/receive could already cause permanent silent data corruption.
>> Of course, only if the conditions you've described below are met.
>>
>>
>>> Given the age of the bug
>>
>> Since when was it in the kernel?
> 
> Since at least 2015.  Note that if you are looking for an end date for
> "clean" data, you may be disappointed.
> 
> In 2016 there were two kernel bugs that silently corrupted reads of
> compressed data.  In 2015 there were...4?  5?  Before 2015 the problems
> are worse, also damaging on-disk compressed data and crashing the kernel.
> The bugs that were present in 2014 were present since compression was
> introduced in 2008.
> 
> With this last fix, as far as I know, we have a kernel that can read
> compressed data without corruption for the first time--at least for a
> subset of use cases that doesn't include direct IO.  Of course I thought
> the same thing in 2017, too, but I have since proven myself wrong.
> 
> When btrfs gets to the point where it doesn't fail backup verification for
> some contiguous years, then I'll be satisfied btrfs (or any filesystem)
> is properly debugged.  I'll still run backup verification then, of
> course--hardware breaks all the time, and broken hardware can corrupt
> any data it touches.  Verification failures point to broken hardware
> much more often than btrfs data corruption bugs.
> 
>>> Even
>>> if
>>> compression is enabled, the file data must be compressed for the bug
>>> to
>>> corrupt it.
>>
>> Is there a simple way to find files (i.e. pathnames) that were actually
>> compressed?
> 
> Run compsize (sometimes the package is named btrfs-compsize) and see if
> there are any lines referring to zlib, zstd, or lzo in the output.
> If it's all "total" and "none" then there's no compression in that file.
> 
> filefrag -v reports non-inline compressed data extents with the "encoded"
> flag, so
> 
> 	if filefrag -v "$file" | grep -qw encoded; then
> 		echo "$file" is compressed, do something here
> 	fi
> 
> might also be a solution (assuming your filename doesn't include the
> string 'encoded').
> 
>>> 	- you never punch holes in files
>>
>> Is there any "standard application" (like cp, tar, etc.) that would do
>> this?
> 
> Legacy POSIX doesn't have the hole-punching concept, so legacy
> tools won't do it; however, people add features to GNU tools all the
> time, so it's hard to be 100% sure without downloading the code and
> reading/auditing/scanning it.  I'm 99% sure cp and tar are OK.
They are, the only things they do with sparse files are creating new 
ones from scratch using the standard seek then write method.  The same 
is true of a vast majority of applications as well.  The stuff most 
people would have to worry about largely comes down to:

* VM software.  Some hypervisors such as QEMU can be configured to 
translate discard commands issued against the emulated block devices to 
fallocate calls to punch holes in the VM disk image file (and QEMU can 
be configured to translate block writes of null bytes to this too), 
though I know of none that do this by default.
* Database software.  This is what stuff like punching holes originated 
for, so it's obviously a potential source of this issue.
* FUSE filesystem drivers.  Most of them that support the required 
fallocate flag to punch holes pass it down directly.  Some make use of 
it themselves too.
* Userspace distributed storage systems.  Stuff like Ceph or Gluster. 
Same arguments as above for FUSE filesystem drivers.
> 
>> What do you mean by clone? refcopy? Would btrfs snapshots or btrfs
>> send/receive be affected?
> 
> clone is part of some file operation syscalls (e.g. clone_file_range,
> dedupe_range) which make two different files, or two different offsets in
> the same file, refer to the same physical extent.  This is the basis of
> deduplication (replacing separate copies with references to a single
> copy) and also of punching holes (a single reference is split into
> two references to the original extent with a hole object inserted in
> the middle).
> 
> "reflink copy" is a synonym for "cp --reflink", which is clone_file_range
> using 0 as the start of range and EOF as the end.  The term 'reflink'
> is sometimes used to refer to any extent shared between files that is
> not the result of a snapshot.  reflink is to extents what a hardlink is
> to inodes, if you ignore some details.
> 
> To trigger the bug you need to clone the same compressed source range
> to two nearly adjacent locations in the destination file (i.e. two or
> more ranges in the source overlap).  cp --reflink never overlaps ranges,
> so it can't create the extent pattern that triggers this bug *by itself*.
> 
> If the source file already has extent references arranged in a way
> that triggers the bug, then the copy made with cp --reflink will copy
> the arrangement to the new file (i.e. if you upgrade the kernel, you
> can correctly read both copies, and if you don't upgrade the kernel,
> both copies will appear to be corrupted, probably the same way).
> 
> I would expect btrfs receive may be affected, but I did not find any
> code in receive that would be affected.  There are a number of different
> ways to make a file with a hole in it, and btrfs receive could use a
> different one not affected by this bug.  I don't use send/receive myself,
> so I don't have historical corruption data to guess from.
> 
>> Or is there anything in btrfs itself which does any of the two per
>> default or on a typical system (i.e. I didn't use dedupe).
> 
> 'btrfs' (the command-line utility) doesn't do these operations as far
> as I can tell.  The kernel only does these when requested by applications.
The receive command will issue clone operations if the sent subvolume 
requires it to get the correct block layout, so there is a 'regular' 
BTRFS operation that can in theory set things up such that the required 
patterns are more likely to happen.
> 
>> Also, did the bug only affect data, or could metadata also be
>> affected... basically should such filesystems be re-created since they
>> may also hold corruptions in the meta-data like trees and so on?
> 
> Metadata is not affected by this bug.  The bug only corrupts btrfs data
> (specificially, the contents of files) in memory, not disk.
> 
>> My scenario looks about the following, and given your explanations, I'd
>> assume I should probably be safe:
>>
>> - my normal laptop doesn't use compress, so it's safe anyway
>>
>> - my cp has an alias to always have --reflink=auto
>>
>> - two 8TB data archive disks, each with two backup disks to which the
>>    data of the two master disks is btrfs sent/received,... which were
>>    all mounted with compress
>>
>>
>> - typically I either cp or mv data from the laptop to these disks,
>>    => should then be safe as the laptop fs didn't use compress,...
>>
>> - or I directly create the files on the data disks (which use compress)
>>    by means of wget, scp or similar from other sources
>>    => should be safe, too, as they probably don't do dedupe/hole
>>       punching by default
>>
>> - or I cp/mv from them camera SD cards, which use some *FAT
>>    => so again I'd expect that to be fine
>>
>> - on vacation I had the case that I put large amount of picture/videos
>>    from SD cards to some btrfs-with-compress mobile HDDs, and back home
>>    from these HDDs to my actual data HDDs.
>>    => here I do have the read / re-write pattern, so data could have
>>       been corrupted if it was compressed + deduped/hole-punched
>>       I'd guess that's anyway not the case (JPEGs/MPEGs don't compress
>>       well)... and AFAIU there would be no deduping/hole-punching
>>       involved here
> 
> dedupe doesn't happen by itself on btrfs.  You have to run dedupe
> userspace software (e.g. duperemove, bees, dduper, rmlint, jdupes, bedup,
> etc...) or build a kernel with dedupe patches.
> 
>> - on my main data disks, I do snapshots... and these snapshots I
>>    send/receive to the other (also compress-mounted) btrfs disks.
>>    => could these operations involve deduping/hole-punching and thus the
>>       corruption?
> 
> Snapshots won't interact with the bug--they are not affected by it
> and will not trigger it.  Send could transmit incorrect data (if it
> uses the kernel's readpages path internally, I don't know if it does).
> Receive seems not to be affected (though it will not detect incorrect
> data from send).
> 
>> Another thing:
>> I always store SHA512 hashsums of files as an XATTR of them (like
>> "directly after" creating such files).
>> I assume there would be no deduping/hole-punching involved till then,
>> so the sums should be from correct data, right?
> 
> There's no assurance of that with this method.  It's highly likely that
> the hashes match the input data, because the file will usually be cached
> in host RAM from when it was written, so the bug has no opportunity to
> appear.  It's not impossible for other system activity to evict those
> cached pages between the copy and hash, so the hash function might reread
> the data from disk again and thus be exposed to the bug.
> 
> Contrast with a copy tool which integrates the SHA512 function, so
> the SHA hash and the copy consume their data from the same RAM buffers.
> This reduces the risk of undetected error but still does not eliminate it.
> A DRAM access failure could corrupt either the data or SHA hash but not
> both, so the hash will fail verification later, but you won't know if
> the hash is incorrect or the data.
> 
> If the source filesystem is not btrfs (and therefore cannot have this
> btrfs bug), you can calculate the SHA512 from the source filesystem and
> copy that to the xattr on the btrfs filesystem.  That reduces the risk
> pool for data errors to the host RAM and CPU, the source filesystem,
> and the storage stack below the source filesystem (i.e.  the generic
> set of problems that can occur on any system at any time and corrupt
> data during copy and hash operations).
> 
>> But when I e.g. copy data from SD, to mobile btrfs-HDD and then to the
>> final archive HDD... corruption could in principle occur when copying
>> from mobile HDD to archive HDD.
>> In that case, would a diff between the two show me the corruption? I
>> guess not because the diff would likely get the same corruption on
>> read?
> 
> Upgrade your kernel before doing any verification activity; otherwise
> you'll just get false results.
> 
> If you try to replace the data before upgrading the kernel, you're more
> likely to introduce new corruption where corruption did not exist before,
> or convert transient corruption events into permanent data corruption.
> You might even miss corrupted data because the bug tends to corrupt data
> in a consistent way.
> 
> Once you have a kernel with the fix applied, diff will show any corruption
> in file copies, though 'cmp -l' might be much faster than diff on large
> binary files.  Use just 'cmp' if you only want to know if any difference
> exists but don't need detailed information, or 'cmp -s' in a shell script.
> 
>> [...]
>> I assume normal mv of refcopy (i.e. cp --reflink=auto) would not punch
>> holes and thus be not affected?
>>
>> Further, I'd assume XATTRs couldn't be affected?
> 
> XATTRs aren't compressed file data, so they aren't affected by this bug
> which only affects compressed file data.
> 
>> So what remains unanswered is send/receive:
>>
>>> btrfs send and receive may be affected, but I don't use them so I
>>> don't
>>> have any experience of the bug related to these tools.  It seems from
>>> reading the btrfs receive code that it lacks any code capable of
>>> punching
>>> a hole, but I'm only doing a quick search for words like "punch", not
>>> a detailed code analysis.
>>
>> Is there some other developer who possibly knows whether send/receive
>> would have been vulnerable to the issue?
>>
>>
>> But since I use send/receive anyway in just one direction from the
>> master to the backup disks... only the later could be affected.
> 
> I presume from this line of questioning that you are not in the habit
> of verifying the SHA512 hashes on your data every few weeks or months.
> If you had that step in your scheduled backup routine, then you would
> already be aware of data corruption bugs that affect you--or you'd
> already be reasonably confident that this bug has no impact on your setup.
> 
> If you had asked questions like "is this bug the reason why I've been
> seeing random SHA hash verification failures for several years?" then
> you should worry about this bug; otherwise, it probably didn't affect you.
> 
>> Thanks,
>> Chris.
>>
>>

