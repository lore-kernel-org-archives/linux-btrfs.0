Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:58358 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770Ab2F0ULW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jun 2012 16:11:22 -0400
Received: by wibhr14 with SMTP id hr14so1452662wib.1
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Jun 2012 13:11:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120627164535.GA2940@localhost.localdomain>
References: <CAAE6i0jGqbOcRbhEYQiLdSUyxaKkFZKQTqb82shaSYdF9jFEqg@mail.gmail.com>
 <CAAE6i0jcfJvBq_JJhO-DVWqBrtEJe1nA7t8k-fqF0BtQY15N4w@mail.gmail.com>
 <CAAE6i0hxv2t0-df+JLtCTC7k8VKTuH-DkUQ7saOSGWSKEV7C2Q@mail.gmail.com>
 <CAAE6i0i7etUgKgGEAzDR6BSruz4AWhaw-0_zvHxwqDAQnyBQ3g@mail.gmail.com>
 <20120627134723.GB2819@localhost.localdomain> <CAAE6i0iN_nv+NfLZ7Tb7e-QVT2oxb7tUC-wnkHdQRxM9sxENiw@mail.gmail.com>
 <20120627164535.GA2940@localhost.localdomain>
From: Chester <somethingsome2000@gmail.com>
Date: Wed, 27 Jun 2012 15:11:00 -0500
Message-ID: <CAAE6i0gVcPX3_Q7XxFZT=tf+tZSTLsitf7NgbS0O95L0Rmn2uw@mail.gmail.com>
Subject: Re: btrfs volume suddenly becomes read-only
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 27, 2012 at 11:45 AM, Josef Bacik <jbacik@fusionio.com> wrote:
>
> On Wed, Jun 27, 2012 at 10:32:22AM -0600, Chester wrote:
> > Hey Josef, the btrfsck was dirty. Here it is pasted inline.
> >
> >
>
> Ok, do btrfsck --repair on the device (the device must be unmounted) and
> hopefully it will fix everything.  Thanks,
>
> Josef

After a --repair run, the extent problem is fixed, but I'm having
another issue where it has a bunch of

warning, bad space info total_bytes NNNNNNN

and then

root 268 inode 199959 errors 4c0
root 804 inode 199959 errors 4c0
root 949 inode 199959 errors 4c0
root 951 inode 199959 errors 4c0
root 1249 inode 199959 errors 4c0
