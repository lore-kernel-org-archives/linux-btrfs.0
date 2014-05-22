Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49261 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751548AbaEVCOK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 May 2014 22:14:10 -0400
Message-ID: <537D5D6F.900@redhat.com>
Date: Wed, 21 May 2014 21:14:07 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Anand Jain <Anand.Jain@oracle.com>, linux-btrfs@vger.kernel.org
CC: rm@romanrm.net
Subject: Re: [PATCH 1/2 v2] btrfs: label should not contain return char
References: <1400519071-5580-1-git-send-email-anand.jain@oracle.com> <1400567808-9494-1-git-send-email-anand.jain@oracle.com> <537B83AD.5010901@redhat.com> <537D5B55.1010207@oracle.com>
In-Reply-To: <537D5B55.1010207@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 5/21/14, 9:05 PM, Anand Jain wrote:
> 
>>
>> (Random aside: why does btrfs support online fs relabeling, anyway?)
>>
>> -Eric
> 
>   Online you mean when mounted ?

Yep - I'm just not sure who would ever want to do that.

Aren't labels primarly used for mounting, during the mount process?

So changing it while mounted seems like a feature looking for a usecase...

-Eric
