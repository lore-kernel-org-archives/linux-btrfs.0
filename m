Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:9119 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752228AbbAPN2B (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 Jan 2015 08:28:01 -0500
Date: Fri, 16 Jan 2015 08:27:50 -0500
From: Chris Mason <clm@fb.com>
Subject: Re: [PATCH] Btrfs: fix typo of variable in scrub_stripe
To: <dsterba@suse.cz>
CC: Tsutomu Itoh <t-itoh@jp.fujitsu.com>, <linux-btrfs@vger.kernel.org>
Message-ID: <1421414870.21014.35@mail.thefacebook.com>
In-Reply-To: <20150116105131.GL3685@twin.jikos.cz>
References: <201501090837.AA00007@WIN-R1VKH1IH438.jp.fujitsu.com>
	<20150116105131.GL3685@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On Fri, Jan 16, 2015 at 5:51 AM, David Sterba <dsterba@suse.cz> wrote:
> On Fri, Jan 09, 2015 at 05:37:52PM +0900, Tsutomu Itoh wrote:
>>  The address that should be freed is not 'ppath' but 'path'.
>> 
>>  Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
> 
> Chris, please add this patch to the next 3.19-rc, the code has been
> introduced during this merge window.

Yes, I've got it queued up here, along with Filipe's v2 from today and 
a few others.

-chris



