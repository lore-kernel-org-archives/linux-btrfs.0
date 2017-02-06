Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:33340 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751942AbdBFMah (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Feb 2017 07:30:37 -0500
Received: by mail-io0-f196.google.com with SMTP id 101so9086525iom.0
        for <linux-btrfs@vger.kernel.org>; Mon, 06 Feb 2017 04:30:36 -0800 (PST)
Received: from [191.9.206.254] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id j79sm4168110itb.0.2017.02.06.04.30.34
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 Feb 2017 04:30:34 -0800 (PST)
Subject: Re: btrfs receive leaves new subvolume modifiable during operation
To: linux-btrfs@vger.kernel.org
References: <1485905578.6441.20.camel@gmail.com>
 <pan$4ecd$16bc5e8e$14657c4$261368ad@cox.net>
 <4edfd08e-8d7f-d8d7-bdea-0589b46e4d2b@gmail.com>
 <7ead5d42-9c00-b2df-3fbf-5b8f287760f6@cobb.uk.net>
 <20170205125458.252c68df@jupiter.sol.kaishome.de>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <a3190ae7-94cc-84b1-bb89-77b1020239b8@gmail.com>
Date: Mon, 6 Feb 2017 07:30:31 -0500
MIME-Version: 1.0
In-Reply-To: <20170205125458.252c68df@jupiter.sol.kaishome.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-02-05 06:54, Kai Krakow wrote:
> Am Wed, 1 Feb 2017 17:43:32 +0000
> schrieb Graham Cobb <g.btrfs@cobb.uk.net>:
>
>> On 01/02/17 12:28, Austin S. Hemmelgarn wrote:
>>> On 2017-02-01 00:09, Duncan wrote:
>>>> Christian Lupien posted on Tue, 31 Jan 2017 18:32:58 -0500 as
>>>> excerpted:
>>  [...]
>>>>
>>>> I'm just a btrfs-using list regular not a dev, but AFAIK, the
>>>> behavior is likely to be by design and difficult to change,
>>>> because the send stream is simply a stream of userspace-context
>>>> commands for receive to act upon, and any other suitably
>>>> privileged userspace program could run the same commands.  (If
>>>> your btrfs-progs is new enough receive even has a dump option,
>>>> that prints the metadata operations in human readable form, one
>>>> operation per line.)
>>>>
>>>> So making the receive snapshot read-only during the transfer would
>>>> prevent receive itself working.
>>> That's correct.  Fixing this completely would require implementing
>>> receive on the kernel side, which is not a practical option for
>>> multiple reasons.
>>
>> I am with Christian on this. Both the effects he discovered go against
>> my expectation of how send/receive would or should work.
>>
>> This first bug is more serious because it appears to allow a
>> non-privileged user to disrupt the correct operation of receive,
>> creating a form of denial-of-service of a send/receive based backup
>> process. If I decided that I didn't want my pron collection (or my
>> incriminating emails) appearing in the backups I could just make sure
>> that I removed them from the receive snapshots while they were still
>> writeable.
>>
>> You may be right that fixing this would require receive in the kernel,
>> and that is undesirable, although it seems to me that it should be
>> possible to do something like allow receive to create the snapshot
>> with a special flag that would cause the kernel to treat it as
>> read-only to any requests not delivered through the same file
>> descriptor, or something like that (or, if that can't be done, at
>> least require root access to make any changes). In any case, I
>> believe it should be treated as a bug, even if low priority, with an
>> explicit warning about the possible corruption of receive-based
>> backups in the btrfs-receive man page.
>
> How about mounting the receiver below a directory only traversable by
> root (chmod og-rwx)? Backups shouldn't be directly accessible by
> ordinary users anyway.
There are perfectly legitimate reasons to have backups directly 
accessible by users.  If you're running automated backups for _their_ 
systems _they_ absolutely should have at least read access to the 
backups _once they're stable_.  This is not a common case, but it is a 
perfectly legitimate one.  In the same way, if you're storing backups 
for your users (in this case you absolutely should not be4 using 
send/receive for other reasons), then the use case dictates that they 
have some way to access them.
>
> If you want a backup becoming accessible, you can later snapshot it to
> an accessible location after send/receive finished without errors.
>
> An in-transit backup, however, should always be protected from possible
> disruptive access. This is an issue with any backup software. So place
> the receive within an inaccessible directory. This is not something the
> backup process should directly bother with for simplicity.
I agree on this point however.  Doing a backup directly into the final 
persistent storage location is never a good idea.  It makes error 
handling more complicated, it makes handling of multi-tier storage more 
complicated (and usually less efficient), and it makes security more 
difficult.

