Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:37851 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756107AbaISNrM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Sep 2014 09:47:12 -0400
Message-ID: <541C33D8.5030000@codethink.co.uk>
Date: Fri, 19 Sep 2014 14:47:04 +0100
From: Sam Thursfield <sam.thursfield@codethink.co.uk>
MIME-Version: 1.0
To: Chris Mason <clm@fb.com>, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        johannes.hirte@datenkhaos.de
Subject: Re: [PATCH] Revert "Btrfs: device_list_add() should not update list
 when
References: <541AF37D.5050505@fb.com>
In-Reply-To: <541AF37D.5050505@fb.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 18/09/14 16:00, Chris Mason wrote:
>
> Johannes and Sam, could you please confirm this patch fixes your mount
> regression for now?  Anand, please make sure I kept the generation check
> properly.

I've just tested this patch on top of 3.17-rc5 and it fixes the issue 
for me.

Thanks!
Sam


-- 
Sam Thursfield, Codethink Ltd.
Office telephone: +44 161 236 5575
