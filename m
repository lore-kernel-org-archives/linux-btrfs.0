From: Felix Blanke <felixblanke@gmail.com>
Subject: Re: Encryption implementation like ZFS?
Date: Sat, 31 Dec 2011 10:53:31 +0100
Message-ID: <20111231095331.GA2829@scooter>
References: <CAELiMBN7vPQ=42eNwT3oGztWS-666RrpzDzv7nDF_LX+0gjxhQ@mail.gmail.com>
 <CANZ96zUydMMYSGoX9QM8p5KSE_17faDCM9ruEeT9peO4_q181A@mail.gmail.com>
 <CAELiMBP9g52fHQv=ur0Kjk+=kO9DWJMCh20RL+-2s_0pS7GVXg@mail.gmail.com>
 <CANZ96zXurbiy=WOOmULcs13fiQomuw=WzDtqm-KFptCx_4TA5A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sandra Schlichting <littlesandra88@gmail.com>,
	linux-btrfs@vger.kernel.org
To: Billy Crook <billycrook@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CANZ96zXurbiy=WOOmULcs13fiQomuw=WzDtqm-KFptCx_4TA5A@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

 Hi,
  
I tried my SSD with luks and it is damn slow. I don't have any numbers for i/o per 
second but the read/write speed was <50% of the speed without luks. If you want 
encryption and speed you have to use loopaes. Unfortunetly you have to patch your
util-linux for that. 
The advantage of loopaes is that it is more secure then luks and way faster.
The speed with encryption (loopaes) is about 90-95% the speed without encryption at
my setup.
           
Best regards,
Felix 


On 30. December 2011 - 14:49, Billy Crook wrote:
> Date:	Fri, 30 Dec 2011 14:49:06 -0600
> From: Billy Crook <billycrook@gmail.com>
> To: Sandra Schlichting <littlesandra88@gmail.com>
> Cc: linux-btrfs@vger.kernel.org
> Subject: Re: Encryption implementation like ZFS?
> 
> On Fri, Dec 30, 2011 at 14:12, Sandra Schlichting
> <littlesandra88@gmail.com> wrote:
> >> How is this advantageous over dmcrypt-LUKS?
> >
> > TRIM pass-through for SSD's. With dmcrypt on an SSD write performance
> > is very slow.
> 
> Good point.  I'm actually very close to moving from magnetic to SSD
> storage for my btrfs volumes.  Would my luks layer offset the majority
> of any advantage I might otherwise see from SSD?  I'd be happy just to
> eliminate seektime.
> 
> > cryptsetup-1.4.0-1 have --enable-discards option to allow
> > discards/TRIM, but it is not recommended for theoretical security
> > reasons.
> >
> > From my understanding some btrfs features wouldn't work with dmcrypt,
> > like "online volume growth and shrinking"?
> 
> I've been using btrfs on luks now for 6 months and online grow works
> fine -- if you online grow the luks container first. (cryptsetup
> resize <name>)  It does make it a more manual process, I suppose, but
> for me it's worth knowing that no part of the filesystem, will ever be
> available should a disk be stolen.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---
