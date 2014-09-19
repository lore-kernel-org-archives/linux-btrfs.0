Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:35819 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754085AbaISN7V (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Sep 2014 09:59:21 -0400
Message-ID: <541C36B0.4030906@fb.com>
Date: Fri, 19 Sep 2014 09:59:12 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Sam Thursfield <sam.thursfield@codethink.co.uk>,
        Anand Jain <anand.jain@oracle.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        <johannes.hirte@datenkhaos.de>
Subject: Re: [PATCH] Revert "Btrfs: device_list_add() should not update list
 when
References: <541AF37D.5050505@fb.com> <541C33D8.5030000@codethink.co.uk>
In-Reply-To: <541C33D8.5030000@codethink.co.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/19/2014 09:47 AM, Sam Thursfield wrote:
> On 18/09/14 16:00, Chris Mason wrote:
>>
>> Johannes and Sam, could you please confirm this patch fixes your mount
>> regression for now?  Anand, please make sure I kept the generation check
>> properly.
> 
> I've just tested this patch on top of 3.17-rc5 and it fixes the issue
> for me.
> 

Perfect, thanks.

-chris

