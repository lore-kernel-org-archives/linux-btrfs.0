From: sniper <s3c24xx@gmail.com>
Subject: Re: [PATCH] Btrfs: simplify iteration codes
Date: Fri, 16 Jan 2009 23:20:06 +0800
Message-ID: <9bd6b5360901160720w3a2950eemaf2cd3e35caec788@mail.gmail.com>
References: <49703687.044e6e0a.04fa.257b@mx.google.com>
	 <1232116274.21473.15.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Qinghuang Feng <qhfeng.kernel@gmail.com>,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1232116274.21473.15.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 16, 2009 at 10:31 PM, Chris Mason <chris.mason@oracle.com> wrote:
> On Fri, 2009-01-16 at 15:25 +0800, Qinghuang Feng wrote:
>> merge list_for_each and list_entry to list_for_each_entry.
>>
>
> Thanks, I've queued this up.
>
Good, but....

Now I have made a new patch for cleanupping all the similar codes in btrfs.
This patch has been tested in VM, it seems ok.

Now should I  rebuild another patch which based the previous patch,
or could you be able to reverse the previous patch then I just post
this new patch including all stuff?

Sorry I am not much familiar with the posting flow, and I am not sure
the meaning of "queued".
