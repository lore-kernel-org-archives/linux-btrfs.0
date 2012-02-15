From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: Problems Implementing Snappy Patches
Date: Wed, 15 Feb 2012 17:14:25 -0600
Message-ID: <CAKcLGm-oLE6kLkPF9XadZpd_XSKnfKZ=CpdjGozz46P4i-Eo3g@mail.gmail.com>
References: <CAKcLGm_AgoHWa1TGwxz6PfSkKvxmDXi_3ykHR10WgTFVW9Gt4g@mail.gmail.com>
	<pan.2012.02.15.23.03.29@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <pan.2012.02.15.23.03.29@cox.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 15, 2012 at 5:03 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> Mitch Harder posted on Wed, 15 Feb 2012 16:46:00 -0600 as excerpted:
>
>> I've been trying to test the snappy compression patches, but I'm get=
ting
>> corruptions when trying to use snappy as built on my system.
>>
>> I'm checking out the Linux 3.2.6 kernel, merging that with the lates=
t
>> 'for-linus' branch on Chris Mason's kernel.org repo, and then
>> integrating the snappy and lz4 patches from David Sterba's git
>> repository (dev/compression-squad branch).
>
> Given that we're past the 3.3 kernel merge window, wouldn't Chris's "=
for-
> linus" branch be based on the patches that went into 3.3, now? =A0IOW=
,
> you're basing on 3.2.x but AFAIK you should be basing on 3.3, now, so
> you're missing the 3.3 patches which CM's for-linus tree branch shoul=
d be
> assuming, at this point.
>

Chris's 'for-linus' branch is currently based on 3.2 (but not 3.2.6).
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
