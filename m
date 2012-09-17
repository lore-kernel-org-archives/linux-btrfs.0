Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:47458 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733Ab2IQEpl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Sep 2012 00:45:41 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by acsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q8H4jcX0017388
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 17 Sep 2012 04:45:39 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q8H4jcBl023100
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 17 Sep 2012 04:45:38 GMT
Received: from abhmt106.oracle.com (abhmt106.oracle.com [141.146.116.58])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q8H4jc8R004007
	for <linux-btrfs@vger.kernel.org>; Sun, 16 Sep 2012 23:45:38 -0500
Message-ID: <5056AB8A.6000500@oracle.com>
Date: Mon, 17 Sep 2012 12:48:10 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs + Btrfs-progs:  make pipe functions re-usable
References: <5052C5A0.4090803@oracle.com> <20120914110432.GE17430@twin.jikos.cz>
In-Reply-To: <20120914110432.GE17430@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


>>   btrfs send introduced a part of code to read kernel-data
>>   from user-end using pipe. We need this part of code to be
>>   useable outside of send sub-cmd, so that developing
>>   service sub-cmd can use it.
>
> What's 'service sub-cmd' please?

   at the moment 'btrfs service history <mnt>|<dev>'
   to show logs of maintenance.
   comments/suggestions welcome.

Thanks
-Anand
