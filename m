Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:33076 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751109AbeBLRJ1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Feb 2018 12:09:27 -0500
Subject: Re: btrfs-cleaner / snapshot performance analysis
To: "Ellis H. Wilson III" <ellisw@panasas.com>, linux-btrfs@vger.kernel.org
References: <346220b8-d129-1de9-eb28-6344ec0b0d3a@panasas.com>
 <96cd9e57-cde4-5bc4-0312-02b54668e59a@mendix.com>
 <76e7f364-62b9-5ef1-a8ed-f6fb9e534963@panasas.com>
 <13d35a99-98ef-5861-3b44-17428d999a7c@mendix.com>
 <bd443816-88e6-acd8-599b-8e34de1ac88c@panasas.com>
 <b5b7fa86-0fa3-84e2-13c8-f63f1b219148@mendix.com>
 <90e07db4-f5c0-9a44-b62d-58c76ed0fa62@panasas.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <c724e286-753d-5cf0-4d8b-a86f39c681a6@mendix.com>
Date: Mon, 12 Feb 2018 18:09:23 +0100
MIME-Version: 1.0
In-Reply-To: <90e07db4-f5c0-9a44-b62d-58c76ed0fa62@panasas.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/12/2018 03:45 PM, Ellis H. Wilson III wrote:
> On 02/11/2018 01:03 PM, Hans van Kranenburg wrote:
>>> 3. I need to look at the code to understand the interplay between
>>> qgroups, snapshots, and foreground I/O performance as there isn't
>>> existing architecture documentation to point me to that covers this
>>
>> Well, the excellent write-up of Qu this morning shows some explanation
>> from the design point of view.
> 
> Sorry, I may have missed this email.  Or perhaps you are referring to a
> wiki or blog post of some kind I'm not following actively?  Either way,
> if you can forward me the link, I'd greatly appreciate it.

You are in the To: of it:

https://www.spinics.net/lists/linux-btrfs/msg74737.html

>> nocow only keeps the cows on a distance as long as you don't start
>> snapshotting (or cp --reflink) those files... If you take a snapshot,
>> then you force btrfs to keep the data around that is referenced by the
>> snapshot. So, that means that every next write will be cowed once again,
>> moo, so small writes will be redirected to a new location, causing
>> fragmentation again. The second and third write can go in the same (new)
>> location of the first new write, but as soon as you snapshot again, this
>> happens again.
> 
> Ah, very interesting.  Thank you for clarifying!

-- 
Hans van Kranenburg
