From: Olaf van der Spek <olafvdspek@gmail.com>
Subject: Re: [PATCH] Btrfs-progs use safe string manipulation functions
Date: Thu, 10 Feb 2011 12:39:22 +0100
Message-ID: <AANLkTi=7B1FLtSrcJ88zgitCBiRctwveRhLzt_2yAHZL@mail.gmail.com>
References: <1297081322.4615.10.camel@monotop>
	<4D53C711.3000309@nsc.liu.se>
	<AANLkTi=OaU8Wj+W2KuPZLbq_85_yVK9mTer9Q7hfTCUc@mail.gmail.com>
	<ij0iku$hbq$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Jeremy Sanders <jeremy@jeremysanders.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <ij0iku$hbq$1@dough.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 10, 2011 at 12:37 PM, Jeremy Sanders
<jeremy@jeremysanders.net> wrote:
> Olaf van der Spek wrote:
>
>> On Thu, Feb 10, 2011 at 12:08 PM, Thomas Bellman <bellman@nsc.liu.se>
>> wrote:
>>> strncpy(args.name, source, BTRFS_PATH_NAME_MAX);
>>> args.name[BTRFS_PATH_NAME_MAX] = '\0';
>>
>> That's silly. Isn't there a sane safe variant of strcpy?
>
> There's strlcpy, but it's not in glibc because of possible truncation
> errors!

Then use a private wrapper.

-- 
Olaf
