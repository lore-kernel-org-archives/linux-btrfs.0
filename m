Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail001.aei.ca ([206.123.6.130]:33610 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966109AbbBCSBn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Feb 2015 13:01:43 -0500
From: Ed Tomlinson <edt@aei.ca>
To: Forrest Liu <forrestl@synology.com>
Cc: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix =?iso-8859-1?Q?find=5Ffree=5Fdev=5Fextent()_malfunction_in_case_device_tr?=
 =?iso-8859-1?Q?ee_has_hole?=
Date: Tue, 03 Feb 2015 13:01:41 -0500
MIME-Version: 1.0
Message-ID: <6a7eaaa1-ee4b-4c8f-905c-c9b6da9ba0b8@aei.ca>
In-Reply-To: <CAJSVwFP89ZSqtL1Y2E12KXE8y+hhs_JkbqWqcidcfvc920HSMw@mail.gmail.com>
References: <1422862299-7361-1-git-send-email-forrestl@synology.com>
 <9348c3e9-9858-4c1a-9489-fab558f1e169@aei.ca>
 <6ada49cc-4bf0-4a9d-8ed7-27754af3639c@aei.ca>
 <CAJSVwFP89ZSqtL1Y2E12KXE8y+hhs_JkbqWqcidcfvc920HSMw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Its a great idea to test the patches before submitting.  However I think 
its even more importent to tell us the state of testing.  eg. this is an 
RFC or in production in abc's kernel, and this version is untested or has 
been compile tested, boot tested, improves xfstests (before x failures out 
of z, after the patch the number of failures was y, where y<x).

A little bit of info like this will help those of us using the info in the 
lists and should aid getting your patches into the kernel faster.

Thanks
Ed

On Tuesday, February 3, 2015 6:36:40 AM EST, Forrest Liu wrote:
> 2015-02-03 2:40 GMT+08:00 Ed Tomlinson <edt@aei.ca>:
>> On Monday, February 2, 2015 9:39:06 AM EST, Ed Tomlinson wrote:
>> 
>> Hi
>> 
>> Booting a kernel with the three patches:
>> [PATCH] Btrfs: fix find_free_dev_extent() malfunction in case device tree
>> has hole ...
>
> My fault, i should test these patches before i submit these patches.
> The oops was caused by patch
> "Btrfs: btrfs_release_extent_buffer_page() didn't free pages of 
> dummy extent"
>
> I will resend these patches after test on linux-3.19-rc7.
>
> Thanks
> Forrest
>
>> Anyone else?
>> 
>> Thanks
>> Ed Tomlinson
>>  ...
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>

