From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: Problems Implementing Snappy Patches
Date: Thu, 16 Feb 2012 07:01:01 -0600
Message-ID: <CAKcLGm9V0FCc=tuYHOYJofNvxBst0g1LiLCLeCPP9NkBLGcRbA@mail.gmail.com>
References: <CAKcLGm_AgoHWa1TGwxz6PfSkKvxmDXi_3ykHR10WgTFVW9Gt4g@mail.gmail.com>
	<4F3C6495.60906@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F3C6495.60906@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 15, 2012 at 8:06 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> Mitch Harder wrote:
>> When I copy directory containing a kernel sources git repository to =
a
>> freshly formated partition mounted with snappy, I get a corrupted
>> copy. =A0If I mount with lzo or lz4 compression, I don't see any
>> corruptions from the copy.
>>
>> I'm not showing any errors in dmesg.
>>
>
> You're not seeing any errors, right?

That is correct.

I'm not seeing any errors thrown out directly from the copy command,
nor am I seeing anything else in the dmesg log.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
