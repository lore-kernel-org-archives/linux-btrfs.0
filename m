Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54103 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752881AbbDXODQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Apr 2015 10:03:16 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAPBX1xJsZ+spTHNLhq+vyHt_ex_wjPGoz6H8fsV3=faNJ0jJyw@mail.gmail.com>
References: <CAPBX1xJsZ+spTHNLhq+vyHt_ex_wjPGoz6H8fsV3=faNJ0jJyw@mail.gmail.com>
To: George Wang <xuw2015@gmail.com>
Cc: dhowells@redhat.com, linux-btrfs@vger.kernel.org
Subject: Re: btrfs/078 may got stuck in the __wait_on_atomic_t
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Date: Fri, 24 Apr 2015 15:03:11 +0100
Message-ID: <30330.1429884191@warthog.procyon.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

George Wang <xuw2015@gmail.com> wrote:

> +       do {
> +               prepare_to_wait(wq, &q->wait, mode);
> +               val = q->key.flags;
> +               if (atomic_read(val) == 0)
> +                       ret = (*action)(val);
> +       } while (!ret && atomic_read(val) != 0);

This isn't what's in the upstream kernel now.  See commit
42577ca8c3616baaafdd8f167b2e1fb959026081.

David
