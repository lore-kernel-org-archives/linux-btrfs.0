Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9191F3EB816
	for <linux-btrfs@vger.kernel.org>; Fri, 26 Jun 2026 10:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782469435; cv=none; b=rBfgkMXcYLGXUdZaf6NYdVU27GVTGWNeFR0W3VOI147lKs/IoFjw28qnsW0+uiyNbIZg4hW5q5a8mO05gRn0cAKUgSZoiEwxppGwVo2s6y6bdBTYTUITD2boFd/BUP7xkxOqxSFpNz0k4omgnmn40/I/aEIIqF/HKVV6Cm6f1so=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782469435; c=relaxed/simple;
	bh=Qwr+5dp+yFYxmWEa6o91TmGPSDaqXuzprYbrB1s2MoA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fCK5t21w6OBAiKfo6nexxe3BCvdiMNbtu6gI4SQ8NbQ4F2l6GgU1QkE3mPLtv+ZY2Vhj4XkEBUsjdaWM5SKoMEOuIBs3eRy061fsYJLPY9pXej68T63ndU63G2oOX7HT6jjzPhAr0156482o2JtUWAvVVsDyhA7AoiWMCZARJdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=C/B5FqqR; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="C/B5FqqR"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4923fb1f095so7592915e9.1
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jun 2026 03:23:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1782469432; x=1783074232; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Lzs37CHTk7DgicK6OAuLqr6L4003x8EvgSSRyy0ZdYI=;
        b=C/B5FqqRzQSkRAKBhirVoS+X6FiEcV0h0gcVvtb9oZDgGU42sZoQQAiDtGKYN0mUs1
         od+gKlvHE8WVosP/mc2KYpUt+tf1e1YCfmGVk/3EjU68zBB/J3el60pPvdkgKxM2eNED
         KiuNO4OEaZg1IHm52npP8HwhGV4+S7hz4zoaXRbnV4QVFYHL6nVHD0nPoQs4TrzS4qPt
         24mCVWxUm1hiYFC5zIWYVdTEjvTwhL4XNF9EIBVSC7mYb0ep1T3MVfDl3dXCpWFWFkLX
         gj/EdA+9bp/VAKqoIhnG5oMiNlc4af1Nd7G5uOJHqMo6RcGOffSv26CnOCodJPDRjT7y
         bVCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782469432; x=1783074232;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lzs37CHTk7DgicK6OAuLqr6L4003x8EvgSSRyy0ZdYI=;
        b=WAu/XvWkWbGmR1tph9c8kXA219QL1sXRwwytwoatNsqaWw+xd1GlAmJN+Fe98BsTN+
         f9UK6EFdYNDLB2vKtsznztx/kCx+dzKoX2HQVw99BgQBS5HJhSU+aGQkF51+krimBCFo
         F3U8eshfANocmIqPmq89bGP4wWKasAM4iNf14SivbMQq1fgLYVl41VkCBkaJwujGy8Gg
         7sJXvr+efK+RVPt2+QvgD2GZ42CFrG8fomjwMZVeNcjD0szKxVYyOCk14b5GG5um+SDF
         eMFfhSxI5OXwx1HHHo0Me+AP52tlQZvDF+3RzrsankIHhwTht4seezIPopxh6w9fKPrY
         v7ew==
X-Gm-Message-State: AOJu0YzwcLWIXthNiBzk0JmkeVXbu/Pq8d5dZgkF7g2Vn6taaZ44Dpou
	2z5G+bAK0mIqHbh7ip+tjnbh3Iqf/NNG6U7HD0rYfGQV4wxhj+evJHu5vQn1pcSKhjo=
X-Gm-Gg: AfdE7cmw7ekg29Qh+4M3gtrkF30qNwsIeyJXkLSr9eLqIe7nXtPLiBj63UJ3JmnYLGk
	+6au2Euj2gVGbjfsVX/HL9U6fEHa9w5I8XxPVx3V3vDh6KU09yvXylAOf+49ve7WBby0vMgbkwb
	TkRJdklAjE9uZMjFFGErexAZ1KmBi6Hb1L5CdO90P5jUElBMH0DLxKpT3IL5KhKf409Vef8uInt
	3GsgfCq75ajk0XHE7c92ZvM2SS+lIgegUNHshJgawW30CybICGmV8K5TP7HOtre3P3UaZEHDWjE
	FGdejsj6tJKyufyYaqpxsmeFesANe4p0t21Dl0hmwV9Ey+bZ0lrBfMtQGEYKjUGj3sR0cK42+NW
	fvc/fNhGtRP/b91U2ftI3JjQNLhDGL7lpkUJTA6Prku46hWFmExqsk+ksj8ORNidJJsnxWlBzcI
	/w5aXK5axkq38gyAAEiSJP5dCMKdMXzejPDYSfytAf
X-Received: by 2002:a05:600c:1d04:b0:492:4714:2d7e with SMTP id 5b1f17b1804b1-492668b76f4mr94619375e9.36.1782469431884;
        Fri, 26 Jun 2026 03:23:51 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c7c8b1a80sm16265208eec.18.2026.06.26.03.23.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Jun 2026 03:23:50 -0700 (PDT)
Message-ID: <46cac806-1f84-4648-a725-6d239763ea0b@suse.com>
Date: Fri, 26 Jun 2026 19:53:42 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] fs: btrfs: implement opendir(), readdir() and
 closedir()
To: Alexey Charkov <alchark@flipper.net>
Cc: linux-btrfs@vger.kernel.org, u-boot@lists.denx.de,
 =?UTF-8?Q?Marek_Beh=C3=BAn?= <kabel@kernel.org>,
 Tom Rini <trini@konsulko.com>, Simon Glass <sjg@chromium.org>,
 =?UTF-8?Q?Timo_tp_Prei=C3=9Fl?= <t.preissl@proton.me>,
 Peng Fan <peng.fan@nxp.com>, Patrice Chotard <patrice.chotard@foss.st.com>,
 Yao Zi <me@ziyao.cc>
References: <20260625-btrfs-readdir-v1-0-dd781a2b3965@flipper.net>
 <20260625-btrfs-readdir-v1-1-dd781a2b3965@flipper.net>
 <bbeac2f6-685d-4ace-b689-10d64c4e3ce5@suse.com>
 <CAKTNdwGH2OCWJ1A=jQWiLYQmxG8UFTBGwGh0Qno7OkUfxs4dtw@mail.gmail.com>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXVgBQkQ/lqxAAoJEMI9kfOh
 Jf6o+jIH/2KhFmyOw4XWAYbnnijuYqb/obGae8HhcJO2KIGcxbsinK+KQFTSZnkFxnbsQ+VY
 fvtWBHGt8WfHcNmfjdejmy9si2jyy8smQV2jiB60a8iqQXGmsrkuR+AM2V360oEbMF3gVvim
 2VSX2IiW9KERuhifjseNV1HLk0SHw5NnXiWh1THTqtvFFY+CwnLN2GqiMaSLF6gATW05/sEd
 V17MdI1z4+WSk7D57FlLjp50F3ow2WJtXwG8yG8d6S40dytZpH9iFuk12Sbg7lrtQxPPOIEU
 rpmZLfCNJJoZj603613w/M8EiZw6MohzikTWcFc55RLYJPBWQ+9puZtx1DopW2jOwE0EWdWB
 rwEIAKpT62HgSzL9zwGe+WIUCMB+nOEjXAfvoUPUwk+YCEDcOdfkkM5FyBoJs8TCEuPXGXBO
 Cl5P5B8OYYnkHkGWutAVlUTV8KESOIm/KJIA7jJA+Ss9VhMjtePfgWexw+P8itFRSRrrwyUf
 E+0WcAevblUi45LjWWZgpg3A80tHP0iToOZ5MbdYk7YFBE29cDSleskfV80ZKxFv6koQocq0
 vXzTfHvXNDELAuH7Ms/WJcdUzmPyBf3Oq6mKBBH8J6XZc9LjjNZwNbyvsHSrV5bgmu/THX2n
 g/3be+iqf6OggCiy3I1NSMJ5KtR0q2H2Nx2Vqb1fYPOID8McMV9Ll6rh8S8AEQEAAcLAfAQY
 AQgAJgIbDBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXWBBQkQ/lrSAAoJEMI9kfOhJf6o
 cakH+QHwDszsoYvmrNq36MFGgvAHRjdlrHRBa4A1V1kzd4kOUokongcrOOgHY9yfglcvZqlJ
 qfa4l+1oxs1BvCi29psteQTtw+memmcGruKi+YHD7793zNCMtAtYidDmQ2pWaLfqSaryjlzR
 /3tBWMyvIeWZKURnZbBzWRREB7iWxEbZ014B3gICqZPDRwwitHpH8Om3eZr7ygZck6bBa4MU
 o1XgbZcspyCGqu1xF/bMAY2iCDcq6ULKQceuKkbeQ8qxvt9hVxJC2W3lHq8dlK1pkHPDg9wO
 JoAXek8MF37R8gpLoGWl41FIUb3hFiu3zhDDvslYM4BmzI18QgQTQnotJH8=
In-Reply-To: <CAKTNdwGH2OCWJ1A=jQWiLYQmxG8UFTBGwGh0Qno7OkUfxs4dtw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/6/26 18:51, Alexey Charkov 写道:
> On Fri, Jun 26, 2026 at 10:38 AM Qu Wenruo <wqu@suse.com> wrote:
[...]
>>
>> So it looks like u-boot only supports the above 3 types, and unlike
>> linux kernel the values doesn't match the btrfs internal ones.
>>
>> In that case, I'd still prefer a proper convertor function.
> 
> Hmm, but the convertor function would still be the same switch
> statement, and it's only used in this single place. Would factoring it
> out actually improve readability?

This is mostly a cross-project tendency.

Inside kernel, we do not need a conversion because all the BTRFS_FT* 
flags matches the FT_* inside kernel.

In progs we have btrfs_type_to_imode() to do the conversion to S_IF* flags.

Thus I'd prefer a convertor, even if there is only a single user.

> 
>> [...]
>>> +
>>> +             *offset = key.offset + 1;
>>> +             type = btrfs_dir_type(path.nodes[0], di);
>>> +
>>> +             /* XATTRs share the key space but are not directory entries. */
>>> +             if (type == BTRFS_FT_XATTR) {
>>
>> This doesn't looks correct again.
>>
>> XATTR has their own keys, they should not show up among DIR_INDEX keys.

Firstly, xattr is per-inode, not per-dentry.
Thus I doubt if you can hit an XATTR type inside a DIR_INDEX.

The easily way to test the theory is just create a simple XATTR for 
compression:

  # mkfs.btrfs -f test.img
  # mount test.img /mnt/btrfs
  # touch /mnt/btrfs/foobar
  # btrfs prop set /mnt/btrfs/foobar compression zstd
  # sync
  # btrfs ins dump-tree -t 5 test.img
  [...]
	item 6 key (257 XATTR_ITEM 550297449) itemoff 15812 itemsize 51
		location key (0 UNKNOWN.0 0) type XATTR
		transid 10 data_len 4 name_len 17
		name: btrfs.compression
		data zstd

You can see that XATTR_ITEM key is for that inode 257, not for the 
parent directory inode (256).


Secondly, if you check the tree-checker.c from the kernel, 
check_dir_item() will reject an XATTR dir type if the key is not 
XATTR_ITEM_KEY.

So even if you really find a btrfs with XATTR dir type but with 
DIR_INDEX key, btrfs will refuse to reject that tree block.

Thanks,
Qu

> 
> Let me double check and adjust accordingly.
> 
> Thanks a lot for your review!
> 
> Best regards,
> Alexey

