Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:63971 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753789AbbJ0Lgn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 Oct 2015 07:36:43 -0400
Date: Tue, 27 Oct 2015 07:36:17 -0400
From: Chris Mason <clm@fb.com>
To: Filipe Manana <fdmanana@gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Josef Bacik <jbacik@fb.com>
Subject: Re: ENOSPC regression in integration-4.4 branch
Message-ID: <20151027113617.GA1492@ret.edimax.com>
References: <CAL3q7H7Fz80P9DMG5B5oZFprMdPcdC44YCZpgECZjaLt4=VY_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAL3q7H7Fz80P9DMG5B5oZFprMdPcdC44YCZpgECZjaLt4=VY_g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 27, 2015 at 09:34:13AM +0000, Filipe Manana wrote:
> Hi Josef,
> 
> Not sure if you are aware or got my report on IRC, but one of the
> allocator fixes/improvements (Chris' integration-4.4 branch) is
> causing new ENOSPC failures:
> 
> http://git.kernel.org/cgit/linux/kernel/git/mason/linux-btrfs.git/commit/?h=integration-4.4&id=a5e681d9bd641c4f0677e87d3a0c92a8f4f16293
> 
> (couldn't find the patch in the mailing list, so starting this thread)
> 
> A few xfstests (generic ones) are now failing, like generic/077 which
> constantly fails for me with:

I was having trouble hitting this consistently, but I did see it in the
integration branch just before heading out to the kernel summit.

-chris
