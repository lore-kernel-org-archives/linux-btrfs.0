Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44941 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbcCKGGQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Mar 2016 01:06:16 -0500
From: Anand Jain <anand.jain@oracle.com>
Subject: Re: [PATCH] Documentation: btrfs: remove usage specific information
To: dsterba@suse.cz, Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        linux-btrfs@vger.kernel.org, clm@fb.com
References: <1457456686-30474-1-git-send-email-dsterba@suse.com>
 <56DF7BDB.8000109@jp.fujitsu.com> <20160309171126.GB18908@suse.cz>
 <56E0CB3D.2030400@oracle.com> <20160310125831.GD18908@twin.jikos.cz>
Message-ID: <56E2604D.9070505@oracle.com>
Date: Fri, 11 Mar 2016 14:06:05 +0800
MIME-Version: 1.0
In-Reply-To: <20160310125831.GD18908@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 03/10/2016 08:58 PM, David Sterba wrote:
> On Thu, Mar 10, 2016 at 09:17:49AM +0800, Anand Jain wrote:
>>
>>
>> On 03/10/2016 01:11 AM, David Sterba wrote:
>>> On Wed, Mar 09, 2016 at 10:26:51AM +0900, Satoru Takeuchi wrote:
>>>>> +that maintains information about administration tasks, frequently asked
>>>>> +questions, use cases, mount options, comprehensible changelogs, features,
>>>>> +manual pages, source code repositories, contacts etc.
>>>>
>>>> About mount options, we also have "man 5 btrfs" and it's
>>>> newer than wiki page's one.
>>>>
>>>> https://www.mail-archive.com/linux-btrfs%40vger.kernel.org/msg34545.html
>>>> commit 26341f734d6d ("btrfs-progs: add mount options to btrfs-mount.5")
>>>>
>>>> Last update:
>>>>    - Btrfs wiki -> Mount options: Sep 19 2015
>>>>    - btrfs-man5.asciidoc: Jan 11 2016
>>>
>>> I'm consolidating the documentation to a single source if possible, at
>>> the moment the wiki page for mount option still exists and lags behind
>>> the manual page. Also the wiki page btrfs-mount hasn't been renamed to
>>> btrfs-man5 and the contents.
>>>
>>> The conversion scripts are at https://github.com/kdave/btrfs-wiki
>>> (/git2wiki) . They're not perfect and sometimes produces strange
>>> artifacts, so this is where it gets stuck.
>>>
>>>> So, how about refer to "man 5 btrfs" from
>>>> "Btrfs wiki -> Mount options -> List of options"
>>>> and/or this document?
>>>
>>> I'd prefer to update the wiki.
>>
>>    Which one would be the master copy ? So it will determine
>>    a process for the steady state production.. either
>>    update wiki and then - sync up to -> man or
>>    update man and then - sync up to -> wiki
>
> I understand Satoru's question whether we should add the reference to
> manual page into Documentation/filesystems/btrfs.txt or to the wiki, and
> I say to the wiki.
>
> You are asking what's the expected process to update the manual pages.
> There's no change, the source is in btrfs-progs git. After a release,
> the manual pages are converted to wiki markup and uploaded.
>
> The wiki page Mount_option is supposed to stay (and updated manually),
> there are external references to it. Its contents might be updated from
> the manual page sources at some point.


  Nice. Thanks for clarifying.

- Anand
