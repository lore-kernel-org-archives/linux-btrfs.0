Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:27889 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221Ab2IRFbG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Sep 2012 01:31:06 -0400
Message-ID: <505807A9.8060401@oracle.com>
Date: Tue, 18 Sep 2012 13:33:29 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: dave@jikos.cz
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs + Btrfs-progs:  make pipe functions re-usable
References: <5052C5A0.4090803@oracle.com> <20120914110432.GE17430@twin.jikos.cz> <5056AB8A.6000500@oracle.com> <20120917145957.GQ17430@twin.jikos.cz>
In-Reply-To: <20120917145957.GQ17430@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


>>> What's 'service sub-cmd' please?
>>
>>    at the moment 'btrfs service history<mnt>|<dev>'
>>    to show logs of maintenance.
>>    comments/suggestions welcome.
>
> Sorry, but without a more detailed description I can hardly give useful
> comments.


David,

   'btrfs service history <mnt>|<dev>'
  is basically to show the list of cli/gui commands which are
  successfully run on the btrfs as part of its -
  creation (may be), configuration and maintenance.

  HTH.

Thanks, Anand

