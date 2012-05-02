From: Bardur Arantsson <spam@scientician.net>
Subject: Re: btrfs across a mix of SSDs & HDDs
Date: Wed, 02 May 2012 04:22:17 +0200
Message-ID: <jnq5os$tdn$1@dough.gmane.org>
References: <jnpdud$ta9$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <jnpdud$ta9$1@dough.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 05/01/2012 09:35 PM, Martin wrote:
> How well does btrfs perform across a mix of:
>
> 1 SSD and 1 HDD for 'raid' 1 mirror for both data and metadata?
>
> Similarly so across 2 SSDs and 2 HDDs (4 devices)?
>
> Can multiple (small) SSDs be 'clustered' as one device and then mirrored
> with one large HDD with btrfs directly? (Other than using lvm...)
>
>
> The idea is to gain the random access speed of the SSDs but have the
> HDDs as backup in case the SSDs fail due to wear...
>
> The usage is to support a few hundred Maildirs + imap for users that
> often have many thousands of emails in the one folder for their inbox...
>
>
> (And no, the users cannot be trained to clean out their inboxes or to be
> more hierarchically tidy... :-( )
>
> Or is btrfs yet too premature to suffer such use?
>

 From Kconfig:

    "Btrfs filesystem (EXPERIMENTAL) Unstable disk format"
                       ^^^^^^^^^^^^   ^^^^^^^^^^^^^^^^^^

Btrfs is too immature to use in ANY kind of production-like scenario 
where you cannot afford to lose a certain amount of data (i.e. be forced 
to restore from backup) AND suffer downtime.

I don't think email users are going to be thrilled about the prospect of 
"lossy" email.

(Not that the other questions aren't valid.)

Regards,

