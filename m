Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp208.alice.it ([82.57.200.104]:49333 "EHLO smtp208.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751716Ab2IZVNI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Sep 2012 17:13:08 -0400
Message-ID: <50636FF0.6010701@libero.it>
Date: Wed, 26 Sep 2012 23:13:20 +0200
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: kreijack@inwind.it
CC: zwu.kernel@gmail.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, jbacik@fusionio.com, dave@jikos.cz,
        linuxram@linux.vnet.ibm.com, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 2/2] btrfs-progs: Fix up memory leakage
References: <1348538536-29838-1-git-send-email-zwu.kernel@gmail.com> <1348538536-29838-3-git-send-email-zwu.kernel@gmail.com> <20120925101429.GR14582@twin.jikos.cz> <5061E676.8080203@libero.it>
In-Reply-To: <5061E676.8080203@libero.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/25/2012 07:14 PM, Goffredo Baroncelli wrote:
> I strongly disagree with this approach. The callee often don't know what
> happen after and before the call. The same is true for the programmer,
> because the code is quite often updated by several people. A clean
> exit() is the right thing to do as general rule.

My fingers were faster than my brain :-)
	s/clean exit()/clean-up/
