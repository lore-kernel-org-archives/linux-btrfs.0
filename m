Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40441 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbbJBIIw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Oct 2015 04:08:52 -0400
Message-ID: <560E3B43.7040102@oracle.com>
Date: Fri, 02 Oct 2015 16:07:31 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, clm@fb.com
Subject: Re: [PATCH 00/23] btrfs device related patch set
References: <1439548388-29686-1-git-send-email-anand.jain@oracle.com> <20150929143406.GD11442@twin.jikos.cz> <560B0C6D.4050100@oracle.com> <20150930150516.GH11442@suse.cz> <20151001144256.GF5885@twin.jikos.cz> <560D4A97.9020705@oracle.com> <20151001161713.GG5885@twin.jikos.cz>
In-Reply-To: <20151001161713.GG5885@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 10/02/2015 12:17 AM, David Sterba wrote:
> On Thu, Oct 01, 2015 at 11:00:39PM +0800, Anand Jain wrote:
>>    Its been challenging to realign the patch sequence at my end as well,
>> I am trying. I think it will take a bit longer than expected.
>
> I'd suggest to send several small patchsets instead of one of such size.
> A big patchset makes sense if all the patches are logically related so
> there's not a limit on the number.
>
> I've picked patches 11, 13, 14, 17, 19, 20 and 22, and made some minor
> changes. I'll do some testing here before I ask Chris to pull the
> updated branch.

David,

  I believe you are applying (11, 13, 14, 17, 19, 20 and 22) on top
  of anand/sysfs-updates-v4.3-rc3. ? which the branch already contains
  8 patches from this set.

  I am rebase-ing rest of the patches on top of these. With RFC
  patches moving to the last in this patching sequence.

Thanks, Anand

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
