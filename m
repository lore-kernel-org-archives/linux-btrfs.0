Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:51214 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752060AbeCHT0x (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Mar 2018 14:26:53 -0500
Date: Thu, 8 Mar 2018 11:26:50 -0800
From: Marc MERLIN <marc@merlins.org>
To: Andrei Borzenkov <arvidjaar@gmail.com>
Cc: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>, fdmanana@gmail.com
Subject: Re: How to change/fix 'Received UUID'
Message-ID: <20180308192650.GA2930@merlins.org>
References: <20180305161619.prnkl4q4zcyibzhc@merlins.org> <32dcf3b9-e810-dc14-1a0b-005f9c49df0a@gmail.com> <20180305194718.GC613@merlins.org> <b323d987-9d97-f57e-b0d6-4ff405abf91c@mendix.com> <20180306200247.svrsko5zr5vldaes@merlins.org> <20180308060612.n655pfxsfh2ehrsf@merlins.org> <8ef51655-a5cf-f970-e541-1bd9de555548@gmail.com> <20180308160209.hua2xuxd72ufiwch@merlins.org> <fe4cd21d-aed1-2509-1c8a-fb4f1e805ce0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <fe4cd21d-aed1-2509-1c8a-fb4f1e805ce0@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 08, 2018 at 09:36:49PM +0300, Andrei Borzenkov wrote:
> Yes. Your source has Received UUID. In this case btrfs send will
> transmit received UUID instead of subvolume UUID as reference to base
> snapshot. You need to either clear received UUID on source or set
> received UUID on destination to received UUID of source (not to
> subvolume UUID of source).

gargamel:/var/local/src/python-btrfs/examples# ./set_received_uuid.py 0e220a4f-6426-4745-8399-0da0084f8b23 313
37 1234.5678 /mnt/btrfs_bigbackup/DS1/Video_ro.20180220_21:03:41                                              
Current subvolume information:                                                                                
  subvol_id: 94887                                                                                            
  received_uuid: 2afc7a5e-107f-d54b-8929-197b80b70828                                                         
  stime: 1234.5678 (1970-01-01T00:20:34.567800)                                                               
  stransid: 31337                                                                                             
  rtime: 1520488877.415709329 (2018-03-08T06:01:17.415709)                                                    
  rtransid: 255755                                                                                            
                                                                                                              
Setting received subvolume...                                                                                 
                                                                                                              
Resulting subvolume information:                                                                              
  subvol_id: 94887                                                                                            
  received_uuid: 0e220a4f-6426-4745-8399-0da0084f8b23                                                         
  stime: 1234.5678 (1970-01-01T00:20:34.567800)                                                               
  stransid: 31337                                                                                             
  rtime: 1520537034.890253770 (2018-03-08T19:23:54.890254)                                                    
  rtransid: 256119                                                                                            
                                                                                                              
gargamel:/var/local/src/python-btrfs/examples# btrfs property set -ts /mnt/btrfs_bigbackup/DS1/Video_ro.201802
20_21:03:41 ro true

This worked fine, thank you so much.
I now have an incremental send that is going on and will take a few dozen minutes instead
of days for 8TB+ :)

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
