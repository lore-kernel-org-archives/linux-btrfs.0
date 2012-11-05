Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36621 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681Ab2KEHZE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Nov 2012 02:25:04 -0500
Message-ID: <509769C0.2040508@oracle.com>
Date: Mon, 05 Nov 2012 15:24:48 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: "Fajar A. Nugraha" <list@fajar.net>
CC: Hugo Mills <hugo@carfax.org.uk>, cwillu <cwillu@cwillu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [Request for review] [RFC] Add label support for snapshots and
 subvols
References: <1351766770-4044-1-git-send-email-Anand.Jain@oracle.com> <CAE5mzvjJmYGJvgjBGLv8kaUnZPDZu_QaU5s1=mYo55RmujeDNQ@mail.gmail.com> <CAG1y0sd-F6WrUFsvwAx+7LGD+V7a6XCoP9=XEkADPEAyEL1G1w@mail.gmail.com> <20121101223253.GA28864@carfax.org.uk> <CAG1y0scEreHgQwFBCABRwbF1_mQaibgPwLBKUOLJD7kV2HL7JA@mail.gmail.com>
In-Reply-To: <CAG1y0scEreHgQwFBCABRwbF1_mQaibgPwLBKUOLJD7kV2HL7JA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>




  Thanks for all the comments and inputs.

  feature    xattr     btrfs-kernel-way
  [1]         No        Yes
  [2]         No        Yes
  [3]         Yes       No


  [1]. Ability to read subvol label without mount
  [2]. Full-ability to log and track the property
       when it is modified
  [3]. risk-free patch ?

  Any comments on why not the btrfs-kernel-way and a review
  of the patch ?

Thanks -Anand


On 11/02/2012 06:49 AM, Fajar A. Nugraha wrote:
> On Fri, Nov 2, 2012 at 5:32 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
>> On Fri, Nov 02, 2012 at 05:28:01AM +0700, Fajar A. Nugraha wrote:
>>> On Fri, Nov 2, 2012 at 5:16 AM, cwillu <cwillu@cwillu.com> wrote:
>>>>>   btrfs fi label -t /btrfs/snap1-sv1
>>>>> Prod-DB-sand-box-testing
>>>>
>>>> Why is this better than:
>>>>
>>>> # btrfs su snap /btrfs/Prod-DB /btrfs/Prod-DB-sand-box-testing
>>>> # mv /btrfs/Prod-DB-sand-box-testing /btrfs/Prod-DB-production-test
>>>> # ls /btrfs/
>>>> Prod-DB  Prod-DB-production-test
>>>
>>>
>>> ... because it would mean possibilty to decouple subvol name from
>>> whatever-data-you-need (in this case, a label).
>>>
>>> My request, though, is to just implement properties, and USER
>>> properties, like what we have in zfs. This seems to be a cleaner,
>>> saner approach. For example, this is on Ubutu + zfsonlinux:
>>>
>>> # zfs create rpool/u
>>> # zfs set user:label="Some test filesystem" rpool/u
>>> # zfs get creation,user:label rpool/u
>>> NAME     PROPERTY    VALUE                  SOURCE
>>> rpool/u  creation    Fri Nov  2  5:24 2012  -
>>> rpool/u  user:label  Some test filesystem   local
>>
>>     Don't we already have an equivalent to that with user xattrs?
>>
>>     Hugo.
>
>
> Anand did say one way to implement the label is by using attr, so +1
> from me for that approach.
>
