From: Daniel Pocock <daniel@pocock.com.au>
Subject: Re: (renamed thread) btrfs metrics
Date: Mon, 02 Jan 2012 17:25:41 +0100
Message-ID: <4F01DA85.4050107@pocock.com.au>
References: <4F01BF5D.2070801@pocock.com.au> <CAE5mzviX5kJ70nG3bLPwE7E3ZjmdQvsKNUbs6XXqVhs+MEeSXw@mail.gmail.com> <4F01C6DC.3040609@pocock.com.au> <20120102151422.GA27122@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Hugo Mills <hugo@carfax.org.uk>, cwillu <cwillu@cwillu.com>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120102151422.GA27122@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>


>    It's actually not possible in general. Since it's possible to have
> different bits of the FS (data vs metadata) with different replication
> levels, one byte written to the FS could take up either 1 or 2 bytes
> of raw disk storage, and there's no way of predicting what the overall
> usage will be, so it's not possible to give an accurate estimate of
> free space.
> 
>    Similarly, if you have a 10G subvolume, and a snapshot of it, then
> how much space does each one take up?

Yes, I agree it is not simple

However, the lvs command from LVM does provide a useful way to show how
full a snapshot volume is.  In the btrfs situation, the snapshot is
within the FS, so it is not quite the same metric

I am looking at what metrics are needed to monitor btrfs in production.
 I actually look after the ganglia-modules-linux package, which includes
some FS space metrics, but I figured that btrfs throws all that out the
window.

Can you suggest metrics that would be meaningful, do I look in /proc or
with syscalls, is there any code I should look at for an example of how
to extract them with C?  Ideally, Ganglia runs without root privileges
too, so please let me know if btrfs will allow me to access them

