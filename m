Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from gitanes.rtfm.co.hu ([80.249.171.82]:40849 "EHLO
	gitanes.rtfm.co.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754917Ab3EaOzt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 31 May 2013 10:55:49 -0400
Message-ID: <51A8B9EF.2070302@martos.bme.hu>
Date: Fri, 31 May 2013 16:55:43 +0200
From: Papp Tamas <tompos@martos.bme.hu>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: oops at mount
References: <51A73532.6060900@martos.bme.hu> <20130530123235.GA9829@localhost.localdomain>
In-Reply-To: <20130530123235.GA9829@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/30/2013 02:32 PM, Josef Bacik wrote:
>
> On Thu, May 30, 2013 at 05:17:06AM -0600, Papp Tamas wrote:
>> hi All,
>>
>> I'm new on the list.
>>
>> System:
>> Distributor ID:	Ubuntu
>> Description:	Ubuntu 13.04
>> Release:	13.04
>> Codename:	raring
>>
>> Linux ctu 3.8.0-19-generic #30-Ubuntu SMP Wed May 1 16:35:23 UTC 2013 x86_64 x86_64 x86_64 GNU/Linux
>>
>> The symptom is the same with Saucy 3.9 kernel.
>
> Can you try btrfs-next
>
> git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-next.git
>
> if it's still not fixed please file a bug at bugzilla.kernel.org and make sure
> the component is set to btrfs.  Thanks,

I did:

https://bugzilla.kernel.org/show_bug.cgi?id=59141

I'm doubt, it will be helpful, as unfortunately I'm not familiar with bug reports regarding to the 
kernel.


Thank you,
tamas
