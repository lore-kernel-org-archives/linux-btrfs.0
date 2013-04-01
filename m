Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37826 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759286Ab3DAWjR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Apr 2013 18:39:17 -0400
Message-ID: <515A0C8A.9090708@oracle.com>
Date: Tue, 02 Apr 2013 06:39:06 +0800
From: anand jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: Jon Nelson <jnelson@jamponi.net>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: device error stats resettable?
References: <CAKuK5J2kjRmoMCsAJv+tdarCkLZn0xykzfuhJ4kjxrR_5VKCGQ@mail.gmail.com>
In-Reply-To: <CAKuK5J2kjRmoMCsAJv+tdarCkLZn0xykzfuhJ4kjxrR_5VKCGQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


 >Is there a way to reset the device
 > error count?
 >

there is -z, is it not what you are looking for ?

------
# btrfs dev stat --help
usage: btrfs device stats [-z] <path>|<device>

     Show current device IO stats. -z to reset stats afterwards.
----

thanks, Anand
