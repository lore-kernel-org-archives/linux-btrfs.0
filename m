Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:42758 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936116Ab2KAWtI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Nov 2012 18:49:08 -0400
Received: by mail-ob0-f174.google.com with SMTP id uo13so3090701obb.19
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Nov 2012 15:49:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20121101223253.GA28864@carfax.org.uk>
References: <1351766770-4044-1-git-send-email-Anand.Jain@oracle.com>
	<CAE5mzvjJmYGJvgjBGLv8kaUnZPDZu_QaU5s1=mYo55RmujeDNQ@mail.gmail.com>
	<CAG1y0sd-F6WrUFsvwAx+7LGD+V7a6XCoP9=XEkADPEAyEL1G1w@mail.gmail.com>
	<20121101223253.GA28864@carfax.org.uk>
Date: Fri, 2 Nov 2012 05:49:07 +0700
Message-ID: <CAG1y0scEreHgQwFBCABRwbF1_mQaibgPwLBKUOLJD7kV2HL7JA@mail.gmail.com>
Subject: Re: [Request for review] [RFC] Add label support for snapshots and subvols
From: "Fajar A. Nugraha" <list@fajar.net>
To: Hugo Mills <hugo@carfax.org.uk>, "Fajar A. Nugraha" <list@fajar.net>,
        cwillu <cwillu@cwillu.com>, Anand jain <Anand.Jain@oracle.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 2, 2012 at 5:32 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Fri, Nov 02, 2012 at 05:28:01AM +0700, Fajar A. Nugraha wrote:
>> On Fri, Nov 2, 2012 at 5:16 AM, cwillu <cwillu@cwillu.com> wrote:
>> >>  btrfs fi label -t /btrfs/snap1-sv1
>> >> Prod-DB-sand-box-testing
>> >
>> > Why is this better than:
>> >
>> > # btrfs su snap /btrfs/Prod-DB /btrfs/Prod-DB-sand-box-testing
>> > # mv /btrfs/Prod-DB-sand-box-testing /btrfs/Prod-DB-production-test
>> > # ls /btrfs/
>> > Prod-DB  Prod-DB-production-test
>>
>>
>> ... because it would mean possibilty to decouple subvol name from
>> whatever-data-you-need (in this case, a label).
>>
>> My request, though, is to just implement properties, and USER
>> properties, like what we have in zfs. This seems to be a cleaner,
>> saner approach. For example, this is on Ubutu + zfsonlinux:
>>
>> # zfs create rpool/u
>> # zfs set user:label="Some test filesystem" rpool/u
>> # zfs get creation,user:label rpool/u
>> NAME     PROPERTY    VALUE                  SOURCE
>> rpool/u  creation    Fri Nov  2  5:24 2012  -
>> rpool/u  user:label  Some test filesystem   local
>
>    Don't we already have an equivalent to that with user xattrs?
>
>    Hugo.


Anand did say one way to implement the label is by using attr, so +1
from me for that approach.

-- 
Fajar
