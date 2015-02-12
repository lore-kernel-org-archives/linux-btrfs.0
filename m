Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from crius.lksmith.net ([66.228.38.125]:51946 "EHLO
	crius.lksmith.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbbBLTSJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Feb 2015 14:18:09 -0500
In-Reply-To: <6D6BEF86-7BFF-4194-9D3E-56145233B34F@lksmith.net>
References: <9E2DE950-1434-424B-974C-2ABE4BD22EE5@opentable.com> <84643B78-D39C-430C-BE12-BBC8DFD7B69F@lksmith.net> <7ACA5140-1C31-45E3-9CF5-9E0BED09FF3D@opentable.com> <6D6BEF86-7BFF-4194-9D3E-56145233B34F@lksmith.net>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: Forever blocked in bit_wait with kernel 3.19
From: Lucas Smith <vedalken@lksmith.net>
Date: Thu, 12 Feb 2015 13:18:06 -0600
To: Steven Schlansker <sschlansker@opentable.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <87A7FDDA-4CFB-45FB-AA99-BD2F63C220F9@lksmith.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Also,

Another thought came to me. It seems that the system only has issues when a sync operation happens. As to Why, I don't know but Maybe someone else on the list can shed some light on this.
end
-- above line is for a mailing list.
-- 
Sent from my Android device with K-9 Mail. Please excuse my brevity.

On February 12, 2015 12:59:36 PM CST, Lucas Smith <vedalken@lksmith.net> wrote:
>Steven, 
>
>The only reason I brought up swap space is that it seems the system may
>be trying to utilize that due to low physical memory. How much RAM in
>the machine running Docker? The main thing that makes me want to
>believe it's RAM is this: [146280.252150]  [<ffffffff81180257>]
>>try_to_free_mem_cgroup_pages+0xa7/0x130
>
>Lucas
>end
>-- above line is for a mailing list.

