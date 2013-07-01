Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:53108 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237Ab3GANkH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Jul 2013 09:40:07 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id D1DD69A04E0
	for <linux-btrfs@vger.kernel.org>; Mon,  1 Jul 2013 07:40:06 -0600 (MDT)
Received: from CAS2.int.fusionio.com (cas2.int.fusionio.com [10.101.1.41]) by mx2.fusionio.com with ESMTP id wjFRXz0EEbr7nNEG (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Mon, 01 Jul 2013 07:40:06 -0600 (MDT)
Date: Mon, 1 Jul 2013 09:40:04 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Josef Bacik <jbacik@fusionio.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: make tree_mod_alloc return the struct its
 allocating
Message-ID: <20130701134004.GF4288@localhost.localdomain>
References: <1372685443-32665-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1372685443-32665-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 01, 2013 at 09:30:43AM -0400, Josef Bacik wrote:
> Lets try and be consistent with every other alloc() type function.
> 
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>

Ignore this, I didn't compile it and I should have, and I'm just going to delete
this function anyway.  Thanks,

Josef
