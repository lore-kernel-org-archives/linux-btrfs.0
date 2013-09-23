Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:56170 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753072Ab3IWCVF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 22 Sep 2013 22:21:05 -0400
Message-ID: <523FA4EB.3060201@cn.fujitsu.com>
Date: Mon, 23 Sep 2013 10:18:19 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Dusty Mabe <dustymabe@gmail.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/9] enhance btrfs qgroup show command
References: <50C068D4.6020105@cn.fujitsu.com> <loom.20130922T170658-776@post.gmane.org> <523F95C4.1080404@cn.fujitsu.com> <CAFfJ-R46gqeMOH3bKPPnghmPZ7CziTmYghXJhgOzEoQ_vTJ6Pw@mail.gmail.com>
In-Reply-To: <CAFfJ-R46gqeMOH3bKPPnghmPZ7CziTmYghXJhgOzEoQ_vTJ6Pw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/23/2013 09:53 AM, Dusty Mabe wrote:
> Hi Wang,
>
> Thank you! There is one other thing I have noticed while playing
> around with quota and qgroups. If I delete subvolumes I can manage to
> get some of the qgroup information to be reported as a negative
> number. If you are interested check out my steps at
> http://dustymabe.com/2013/09/22/btrfs-how-big-are-my-snapshots/ . The
> system I was using was Fedora 19 (so not the latest stuff so this may
> be a known issue already).
I will take a look at this issue.

Thanks,
Wang
>
> Feel free to share the post if you think it could help anyone.
>
> Dusty
>
> On Sun, Sep 22, 2013 at 9:13 PM, Wang Shilong
> <wangsl.fnst@cn.fujitsu.com> wrote:
>> On 09/22/2013 11:14 PM, Dusty Mabe wrote:
>>> Miao Xie <miaox <at> cn.fujitsu.com> writes:
>>>
>>>> The patchset enhanced btrfs qgroup show command.
>>>>
>>>> Firstly, we restructure show_qgroups, make it easy to add new features.
>>>>
>>>> And then we add '-p' '-c', '-l',and '-e' options to print the parent
>>>> qgroup id, child qgroup id, max referenced size and max exclusive size
>>>> of qgroup respectively, add '-F' and '-f' option to list qgroups that
>>>> impact the given path.
>>> Hi,
>>>
>>> What is the status of this patch? I don't ever think it made it in upstream.
>>> Was it flawed or just forgotten?
>> I will rebase this patchset and resend.
>>
>> Thanks,
>> Wang
>>> Thanks,
>>> Dusty
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

