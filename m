Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47978 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763588Ab3DDRji (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Apr 2013 13:39:38 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r34HdZF7021212
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 4 Apr 2013 17:39:38 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r34HdYMr006577
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 4 Apr 2013 17:39:35 GMT
Received: from abhmt111.oracle.com (abhmt111.oracle.com [141.146.116.63])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r34HdYoj012761
	for <linux-btrfs@vger.kernel.org>; Thu, 4 Apr 2013 12:39:34 -0500
Message-ID: <515DBACF.8020202@oracle.com>
Date: Fri, 05 Apr 2013 01:39:27 +0800
From: anand jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: a scenario of use backup sb by default
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--
  mkfs.btrfs /dev/dm-4 -f
  mkfs.ext4 /dev/dm-4 <-- corrupt the primary SB
--

  as of now

--
  btrfs fi label /dev/dm-4 "test"
  btrfs fi label /dev/dm-4
  test
--

  is successful since its using backup super block
  by default, is this fine ?


Thanks, Anand
