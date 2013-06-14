Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38681 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754880Ab3FNBuM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Jun 2013 21:50:12 -0400
Message-ID: <51BA77B3.7060706@oracle.com>
Date: Fri, 14 Jun 2013 09:53:55 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs-progs and btrfs code similar why ?
References: <51B942E3.8000701@oracle.com> <51B94E47.1070900@redhat.com>
In-Reply-To: <51B94E47.1070900@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> Because they work with the same on-disk structures, and need
> to perform many of the same tasks.  So using the same code base
> means bugs get fixed once, features get written once, there is
> built-in consistency, more coverage, etc.

  yes. Thanks Eric.

- Anand
