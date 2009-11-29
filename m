From: "Jean-Philippe Robichaud" <jean.philippe.robichaud@gmail.com>
Subject: Re: unexpected raid1 behavior?
Date: Sun, 29 Nov 2009 16:28:26 -0500
Message-ID: <200911291628.26997.jean.philippe.robichaud@gmail.com>
References: <200911271541.17451.jean.philippe.robichaud@gmail.com> <200911271736.22930.jean.philippe.robichaud@gmail.com> <20091129124256.GA17897@cumulus>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20091129124256.GA17897@cumulus>
List-ID: <linux-btrfs.vger.kernel.org>

On Sunday 29 November 2009 07:42:56 Sander wrote:
> Hello Jean-Philippe,
> 
> Jean-Philippe Robichaud wrote (ao):
> > Is there a place in /sys or /proc where I could perhaps get 'stats'
> > about the btrfs volume?
> 
> I think btrfs-show should help you there.
> 
> 	With kind regards, Sander
> 
Sure: here it goes:

# sudo btrfs-show
failed to read /dev/sr0

Label: none  uuid: fb9270b4-8779-489f-a599-eaab299d4633
        Total devices 2 FS bytes used 78.98GB
        devid    1 size 341.69GB used 146.03GB path /dev/sda5
        devid    2 size 341.69GB used 146.01GB path /dev/sdb5

