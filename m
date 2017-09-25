Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:34967 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S932364AbdIYIgk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Sep 2017 04:36:40 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dwOsQ-0007jc-SD
        for linux-btrfs@vger.kernel.org; Mon, 25 Sep 2017 10:36:30 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: Btrfs performance with small blocksize on SSD
Date: Mon, 25 Sep 2017 10:36:31 +0200
Message-ID: <20170925103631.1dce28ae@jupiter.sol.kaishome.de>
References: <3321b3c199da4d378bbfa3dbac3c4059@rwth-aachen.de>
        <f05a6500-19d6-fc7c-7461-905417c855b7@gmx.com>
        <b9067303023a49158bae2cdc34393716@rwth-aachen.de>
        <ffd3bf37-3029-9f6e-5d57-6d8cca74fdad@gmail.com>
        <a7bde40e8fa8416c888e8c65a7442b65@rwth-aachen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Mon, 25 Sep 2017 07:04:14 +0000
schrieb "Fuhrmann, Carsten" <carsten.fuhrmann@rwth-aachen.de>:

> Well the correct translation for "Laufzeit" is runtime and not
> latency. But thank you for that hint, I'll change it to "gesamt
> Laufzeit" to make it more clear.

How about better translating it to English in the first place as you're
trying to reach an international community?

Also, it would be nice to put the exact test you did as a command line
or configuration file, so it can be replayed on other systems, and -
most important - by the developers, to easily uncover what is causing
the behavior...


> Best regards
> 
> Carsten
> 
> -----Ursprüngliche Nachricht-----
> Von: Andrei Borzenkov [mailto:arvidjaar@gmail.com] 
> Gesendet: Sonntag, 24. September 2017 18:43
> An: Fuhrmann, Carsten <carsten.fuhrmann@rwth-aachen.de>; Qu Wenruo
> <quwenruo.btrfs@gmx.com>; linux-btrfs@vger.kernel.org Betreff: Re:
> AW: Btrfs performance with small blocksize on SSD
> 
> 24.09.2017 16:53, Fuhrmann, Carsten пишет:
> > Hello,
> > 
> > 1)
> > I used direct write (no page cache) but I didn't disable the Disk
> > cache of the HDD/SSD itself. In all tests I wrote 1GB and looked
> > for the runtime of that write process.  
> 
> So "latency" on your diagram means total time to write 1GiB file?
> That is highly unusual meaning for "latency" which normally means
> time to perform single IO. If so, you should better rename Y-axis to
> something like "total run time".
> N_____r__y____b_X____v_^_)__{.n_+____{_n___)____w*jg__________j/___z_____2_______&_)___a_____G___h__j:+v___w____


-- 
Regards,
Kai

Replies to list-only preferred.


