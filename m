From: Steve Freitas <sflist@ihonk.com>
Subject: Re: btrfs volume mounts and dies (was Re: Segfault in btrfsck)
Date: Wed, 06 Jan 2010 07:59:55 -0800
Message-ID: <1262793595.6214.5.camel@phat>
References: <1262476565.17096.20.camel@phat>
	 <1262559421.17096.50.camel@phat> <1262565474.17096.68.camel@phat>
	 <1262732153.4509.1.camel@phat>  <20100106075253.GA5665@cumulus>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100106075253.GA5665@cumulus>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Sander,

On Wed, 2010-01-06 at 08:52 +0100, Sander wrote:
> I don't have your original mail, but I think I remember you mentioned a
> lot of bad sectors on that disk reported by SMART.
> 
> If that is indeed the case it might be dificult for the people who might
> be able to help you, to help you.

Thanks for your  response. You're correct about the bad sector warning.
So please correct me if I have some mistaken assumptions. I thought
btrfs would be tolerant of that -- if a block failed the checksum test,
it would reconstruct and remap it. (Also, I assumed that if a drive
hadn't filled its bad sector remapping table, it could handle it at the
hardware level, and SMART's warning was just that -- a warning, not a
dire pronouncement of utter unsuitability -- but that's something else.)

Steve

