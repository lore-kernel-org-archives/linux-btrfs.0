Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45354 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752845Ab3KGBZm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 Nov 2013 20:25:42 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VeELs-0006RB-VZ
	for linux-btrfs@vger.kernel.org; Thu, 07 Nov 2013 02:25:40 +0100
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginm.net ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Nov 2013 02:25:40 +0100
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginm.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Nov 2013 02:25:40 +0100
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: [PATCH] Btrfs-progs: allow --init-extent-tree to work when extent
 tree is borked
Date: Thu, 07 Nov 2013 01:25:26 +0000
Message-ID: <l5eq5s$m8l$1@ger.gmane.org>
References: <1382724100-5276-1-git-send-email-jbacik@fusionio.com> <l4ed62$8r3$1@ger.gmane.org> <20131025183134.GA4543@localhost.localdomain> <l4hifj$ni1$1@ger.gmane.org> <20131028151148.GB4543@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
In-Reply-To: <20131028151148.GB4543@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 28/10/13 15:11, Josef Bacik wrote:
> On Sun, Oct 27, 2013 at 12:16:12AM +0100, Martin wrote:
>> On 25/10/13 19:31, Josef Bacik wrote:
>>> On Fri, Oct 25, 2013 at 07:27:24PM +0100, Martin wrote:
>>>> On 25/10/13 19:01, Josef Bacik wrote:
>>>>> Unfortunately you can't run --init-extent-tree if you can't actually read the
>>>>> extent root.  Fix this by allowing partial starts with no extent root and then
>>>>> have fsck only check to see if the extent root is uptodate _after_ the check to
>>>>> see if we are init'ing the extent tree.  Thanks,
>>>>>
>>>>> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
>>>>> ---
>>>>>  cmds-check.c |  9 ++++++---
>>>>>  disk-io.c    | 16 ++++++++++++++--
>>>>>  2 files changed, 20 insertions(+), 5 deletions(-)
>>>>>
>>>>> diff --git a/cmds-check.c b/cmds-check.c
>>>>> index 69b0327..8ed7baa 100644
>>>>> --- a/cmds-check.c
>>>>> +++ b/cmds-check.c
>>>>
>>>> Hey! Quick work!...
>>>>
>>>> Is that worth patching locally and trying against my example?
>>>>
>>>
>>> Yes, I'm a little worried about your particular case so I'd like to see if it
>>> works.  If you don't see a lot of output after say 5 minutes let's assume I
>>> didn't fix your problem and let me know so I can make the other change I
>>> considered.  Thanks,
>>
>> Nope... No-go.
>>
> 
> Ok I've sent
> 
> [PATCH] Btrfs-progs: rework open_ctree to take flags, add a new one
> 
> which should address your situation.  Thanks,


Josef,

Tried your patch:

####
Signed-off-by: Josef Bacik <jbacik@fusionio.com>

 13 files changed, 75 insertions(+), 113 deletions(-)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index 26c7b5f..ae10eed 100644
####

And the patching fails due to mismatching code...

I have the Gentoo source for:

Btrfs v0.20-rc1-358-g194aa4a

(On Gentoo 3.11.5, will be on 3.11.6 later today.)


What are the magic incantations to download your version of source code
to try please? (Patched or unpatched?)


Many thanks,
Martin


