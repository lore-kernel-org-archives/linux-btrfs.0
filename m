Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53894 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754438Ab3KOKgI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Nov 2013 05:36:08 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VhGkw-00077E-Ue
	for linux-btrfs@vger.kernel.org; Fri, 15 Nov 2013 11:36:06 +0100
Received: from barriere.frankfurter-softwarefabrik.de ([217.11.197.1])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Nov 2013 11:36:06 +0100
Received: from lvml by barriere.frankfurter-softwarefabrik.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Nov 2013 11:36:06 +0100
To: linux-btrfs@vger.kernel.org
From: Lutz Vieweg <lvml@5t9.de>
Subject: Re: Mixed and raid [was Re: BUG: btrfsRe: Does btrfs "raid1" actually
 provide any resilience?]
Date: Fri, 15 Nov 2013 11:35:54 +0100
Message-ID: <5285F90A.90605@5t9.de>
References: <l62akc$ujc$1@ger.gmane.org> <528514CA.8080903@libero.it> <528536F7.6030503@libero.it> <52853ED2.8040606@libero.it> <5285A6AF.8090607@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: kreijack@inwind.it, linux-btrfs@vger.kernel.org
In-Reply-To: <5285A6AF.8090607@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/15/2013 05:44 AM, Anand Jain wrote:
>   Thanks for the test case and heads-up on this. The code missed
>   the check if the user has provided the option before default
>   profile for the mixed group (due to small vol) is enforced.
>
>   I have sent out the following patch to fix it.
>
> [PATCH] btrfs-progs: for mixed group check opt before default raid profile is enforced
>
>   Kindly let us know how it performed if you could.

I just tried it: The test case I posted now works as expected.

Thanks a lot for your effort!

(The patch did not apply to the current head of
  git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git
  without manual intervention, but was easy to fix.)

Regards,

Lutz Vieweg

PS: Will now proceed with some less basic resilience tests... ;-)

