Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f172.google.com ([209.85.220.172]:55231 "EHLO
        mail-qk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751907AbdJLLNi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Oct 2017 07:13:38 -0400
Received: by mail-qk0-f172.google.com with SMTP id n5so790964qke.11
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Oct 2017 04:13:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <59df4db2.8508370a.40c79.2c64.GMRIR@mx.google.com>
References: <CAH-drow6AB9vu84DJGB90bbvE7DZnJ+eZOvJmxu9w1rHA5CrNA@mail.gmail.com>
 <20171007000837.GD19068@lim.localdomain> <CAH-droxSCv9CfPE2gDAmmDV33ucjh7nABNvmv=fsCzdewcm7rQ@mail.gmail.com>
 <CAJCQCtRYkEQzCVqTbeE5cxOffFmqB5TFoU5wXaneZ+34NefaFA@mail.gmail.com>
 <CAH-drozNA1N6xO2dAknLD-JQu75BAEi+GpiEibA-R-Zk1U7xmA@mail.gmail.com>
 <CAJCQCtSchpVsL2Gr3dm+4MQuHDBU96UG9Gf_imBWqXRMD01+yw@mail.gmail.com>
 <CAH-drozVaiXMoXqs8hiHvd5n8qDvbGLnp=1OPndsibhxjGkNxw@mail.gmail.com>
 <CAH-drozVaiXMoXqs8hiHvd5n8qDvbGLnp=1OPndsibhxjGkNxw@mail.gmail.com> <59df4db2.8508370a.40c79.2c64.GMRIR@mx.google.com>
From: Nick Gilmour <nickeforos@gmail.com>
Date: Thu, 12 Oct 2017 13:12:57 +0200
Message-ID: <CAH-drozKBR7T7xg80HdP5gm_R_3co3ZJEpTCC8yeSj9-aoBJDA@mail.gmail.com>
Subject: Re: Delivery Status Notification (Failure)
To: Chris Murphy <lists@colorremedies.com>
Cc: Liu Bo <bo.li.liu@oracle.com>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for the detailed description!

It makes all sense. My question was rather stupid.

I shrunk the partition with gparted (I suppose it uses the btrfs
resize command) and then cloned the partition with clonezilla. I tried
to create a zvol of the same size but I got an error about the size (I
don't remember exactly), so I used qemu to expand the img. Then
imported the zvol into VMM and started the VM but I got again a blue
screen with the same error. After that I gave up and created a new VM.

Regards,
Nick

On Thu, Oct 12, 2017 at 1:10 PM, Mail Delivery Subsystem
<mailer-daemon@googlemail.com> wrote:
> Message may contain a virus
>
> Your message wasn't delivered to linux-btrfs@vger.kernel.org because it may
> contain a virus. Learn how to check for and prevent viruses.
> The response from the remote server was:
>
> 550 5.7.1 Content-Policy reject msg: The message contains HTML subpart,
> therefore we consider it SPAM or Outlook Virus. TEXT/PLAIN is accepted.!
> BF:<U 0.499737>; S1751350AbdJLLKl
>
>
> Final-Recipient: rfc822; linux-btrfs@vger.kernel.org
> Action: failed
> Status: 5.7.1
> Remote-MTA: dns; vger.kernel.org. (209.132.180.67, the server for the domain
> vger.kernel.org.)
> Diagnostic-Code: smtp; 550 5.7.1 Content-Policy reject msg: The message
> contains HTML subpart, therefore we consider it SPAM or Outlook Virus.
> TEXT/PLAIN is accepted.! BF:<U 0.499737>; S1751350AbdJLLKl
> Last-Attempt-Date: Thu, 12 Oct 2017 04:10:42 -0700 (PDT)
>
