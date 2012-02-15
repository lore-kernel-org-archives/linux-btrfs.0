From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: [PATCH 1/3] Add the snappy-c compressor to lib v2
Date: Tue, 14 Feb 2012 18:43:35 -0600
Message-ID: <CAKcLGm_YeQbaenjdCg2--Gzr61SxYXP0xRPZJEtPHADiMcn0EA@mail.gmail.com>
References: <1326414530-10789-1-git-send-email-andi@firstfloor.org>
	<1326414530-10789-2-git-send-email-andi@firstfloor.org>
	<CAKcLGm8u9oKEBjFW3VpLZDUd=56mRRrr-_zjf-M7Hf5NpTTM8Q@mail.gmail.com>
	<4F3ABB66.1040202@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Andi Kleen <andi@firstfloor.org>, chris.mason@oracle.com,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Andi Kleen <ak@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4F3ABB66.1040202@linux.intel.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 14, 2012 at 1:52 PM, Andi Kleen <ak@linux.intel.com> wrote:
>
>> (BTW: =A0If you're ever reworking this patch set, I'd like to make a=
n ad
>> hoc request for slightly different names for fs/btrfs/snappy.c and
>> lib/snappy.c)
>
>
> Why?
>

It's not a big deal, I just found it confusing at first to see
"snappy.c" being a different file in two places.
