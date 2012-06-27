Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:56740 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756086Ab2F0Qpj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jun 2012 12:45:39 -0400
Date: Wed, 27 Jun 2012 12:45:36 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Chester <somethingsome2000@gmail.com>
CC: Josef Bacik <JBacik@fusionio.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs volume suddenly becomes read-only
Message-ID: <20120627164535.GA2940@localhost.localdomain>
References: <CAAE6i0jGqbOcRbhEYQiLdSUyxaKkFZKQTqb82shaSYdF9jFEqg@mail.gmail.com>
 <CAAE6i0jcfJvBq_JJhO-DVWqBrtEJe1nA7t8k-fqF0BtQY15N4w@mail.gmail.com>
 <CAAE6i0hxv2t0-df+JLtCTC7k8VKTuH-DkUQ7saOSGWSKEV7C2Q@mail.gmail.com>
 <CAAE6i0i7etUgKgGEAzDR6BSruz4AWhaw-0_zvHxwqDAQnyBQ3g@mail.gmail.com>
 <20120627134723.GB2819@localhost.localdomain>
 <CAAE6i0iN_nv+NfLZ7Tb7e-QVT2oxb7tUC-wnkHdQRxM9sxENiw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAAE6i0iN_nv+NfLZ7Tb7e-QVT2oxb7tUC-wnkHdQRxM9sxENiw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 27, 2012 at 10:32:22AM -0600, Chester wrote:
> Hey Josef, the btrfsck was dirty. Here it is pasted inline.
> 
> 

Ok, do btrfsck --repair on the device (the device must be unmounted) and
hopefully it will fix everything.  Thanks,

Josef
