Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f48.google.com ([209.85.219.48]:60169 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892Ab3IWBxW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 22 Sep 2013 21:53:22 -0400
Received: by mail-oa0-f48.google.com with SMTP id m6so131537oag.21
        for <linux-btrfs@vger.kernel.org>; Sun, 22 Sep 2013 18:53:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <523F95C4.1080404@cn.fujitsu.com>
References: <50C068D4.6020105@cn.fujitsu.com> <loom.20130922T170658-776@post.gmane.org>
 <523F95C4.1080404@cn.fujitsu.com>
From: Dusty Mabe <dustymabe@gmail.com>
Date: Sun, 22 Sep 2013 21:53:02 -0400
Message-ID: <CAFfJ-R46gqeMOH3bKPPnghmPZ7CziTmYghXJhgOzEoQ_vTJ6Pw@mail.gmail.com>
Subject: Re: [PATCH 0/9] enhance btrfs qgroup show command
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Wang,

Thank you! There is one other thing I have noticed while playing
around with quota and qgroups. If I delete subvolumes I can manage to
get some of the qgroup information to be reported as a negative
number. If you are interested check out my steps at
http://dustymabe.com/2013/09/22/btrfs-how-big-are-my-snapshots/ . The
system I was using was Fedora 19 (so not the latest stuff so this may
be a known issue already).

Feel free to share the post if you think it could help anyone.

Dusty

On Sun, Sep 22, 2013 at 9:13 PM, Wang Shilong
<wangsl.fnst@cn.fujitsu.com> wrote:
> On 09/22/2013 11:14 PM, Dusty Mabe wrote:
>> Miao Xie <miaox <at> cn.fujitsu.com> writes:
>>
>>> The patchset enhanced btrfs qgroup show command.
>>>
>>> Firstly, we restructure show_qgroups, make it easy to add new features.
>>>
>>> And then we add '-p' '-c', '-l',and '-e' options to print the parent
>>> qgroup id, child qgroup id, max referenced size and max exclusive size
>>> of qgroup respectively, add '-F' and '-f' option to list qgroups that
>>> impact the given path.
>>
>> Hi,
>>
>> What is the status of this patch? I don't ever think it made it in upstream.
>> Was it flawed or just forgotten?
> I will rebase this patchset and resend.
>
> Thanks,
> Wang
>>
>> Thanks,
>> Dusty
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
