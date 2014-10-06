Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:39876 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752497AbaJFWWU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 Oct 2014 18:22:20 -0400
Date: Mon, 6 Oct 2014 18:22:11 -0400
From: Chris Mason <clm@fb.com>
Subject: Re: btrfs send and kernel 3.17
To: David Arendt <admin@prnet.org>
CC: <linux-btrfs@vger.kernel.org>
Message-ID: <1412634131.2562.0@mail.thefacebook.com>
In-Reply-To: <543300EF.2070308@prnet.org>
References: <543300EF.2070308@prnet.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 6, 2014 at 4:51 PM, David Arendt <admin@prnet.org> wrote:
> I just tried downgrading to 3.16.3 again. In 3.16.3 btrfs send is
> working without any problem. Afterwards I upgraded again to 3.17 and 
> the
> problem reappeared. So the problem seems to be kernel version related.

[ backref errors during btrfs-send ]

Ok then, our list of suspects is pretty short.  Can you easily build 
test kernels?

I'd like to try reverting this commit:

51f395ad4058883e4273b02fdebe98072dbdc0d2

-chris


