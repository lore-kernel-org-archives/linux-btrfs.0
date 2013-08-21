Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44682 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085Ab3HUDlQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Aug 2013 23:41:16 -0400
Message-ID: <52143858.8020904@oracle.com>
Date: Wed, 21 Aug 2013 11:47:36 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: return btrfs error code for dev excl ops err
References: <1376979054-2883-1-git-send-email-anand.jain@oracle.com> <1376979054-2883-2-git-send-email-anand.jain@oracle.com> <20130820183405.GH3990@localhost.localdomain>
In-Reply-To: <20130820183405.GH3990@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>




>> -			return "add/delete/balance/replace/resize operation "\
>> -				"in progress";
>> +			return "add/delete/balance/replace/resize operation in progress";
>>   		default:
>>   			return NULL;
>
> This is an unnecessary change.  Thanks,

  Hmm. ok. v2 sent out.


