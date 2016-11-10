Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mbox.akmail.it ([213.21.176.227]:50769 "EHLO pop.aknet.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755335AbcKJNBI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 Nov 2016 08:01:08 -0500
Message-ID: <1478782854.58246f86295b0@webmail.adria.it>
Date: Thu, 10 Nov 2016 14:00:54 +0100
From: bepi@adria.it
To: Alex Powell <alexj.powellalt@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re:
References: <1478714157.5823632d5829d@webmail.adria.it> <CAKGv6Coc4vzsJsJ8=AEP1-vcdDzCcNeeGAoerkMwaukAowOzwA@mail.gmail.com>
In-Reply-To: <CAKGv6Coc4vzsJsJ8=AEP1-vcdDzCcNeeGAoerkMwaukAowOzwA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi.

P.S. Sorry for the double sending and for the blank email subject.


Yes.
The various controls are designed to be used separated, and to be launched both
as cronjobs and manually.

For example 
you can create a series of snapshots

  btrsfManage SNAPSHOT /

and send the new snapshots (incremental stream)

  btrsfManage SEND / /dev/sda1

in cronjobs or manually, it is indifferent.


Best regards.

Gdb

Scrive Alex Powell <alexj.powellalt@googlemail.com>:

> Hi,
> It would be good but perhaps each task should be created via cronjobs
> instead of having a script running all the time or one script via one
> cronjob
> 
> Working in the enterprise environment for a major bank, we quickly
> learn that these sort of daily tasks should be split up
> 
> Kind Regards,
> Alex
> 
> On Thu, Nov 10, 2016 at 4:25 AM,  <bepi@adria.it> wrote:
> > Hi.
> >
> > I'm making a script for managing btrfs.
> >
> > To perform the scrub, to create and send (even to a remote system) of the
> backup
> > snapshot (or for one copy of the current state of the data).
> >
> > The script is designed to:
> > - Be easy to use:
> >   - The preparation is carried out automatically.
> >   - Autodetect of the subvolume mounted.
> > - Be safe and robust:
> >   - Check that not exist a another btrfs managing already started.
> >   - Subvolume for created and received snapshot are mounted and accessible
> only
> >     for the time necessary to perform the requested operation.
> >   - Verify that the snapshot and sending snapshot are been executed
> completely.
> >   - Progressive numbering of the snapshots for identify with certainty
> >     the latest snapshot.
> >
> > Are also available command for view the list of snaphost present, command
> for
> > delete the snapshots.
> >
> > For example:
> >
> > btrsfManage SCRUB /
> > btrsfManage SNAPSHOT /
> > btrsfManage SEND / /dev/sda1
> > btrsfManage SEND / root@gdb.exnet.it/dev/sda1
> > btrsfManage SNAPLIST /dev/sda1
> > btrsfManage SNAPDEL /dev/sda1 "root-2016-11*"
> >
> > You are interested?
> >
> > Gdb
> >
> >
> > ----------------------------------------------------
> > This mail has been sent using Alpikom webmail system
> > http://www.alpikom.it
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 




----------------------------------------------------
This mail has been sent using Alpikom webmail system
http://www.alpikom.it

