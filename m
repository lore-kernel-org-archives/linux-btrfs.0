From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: snapper for Ubuntu? (WAS: btrfs auto snapshot)
Date: Tue, 10 Apr 2012 21:50:32 +0700
Message-ID: <CAG1y0sdnXMuq4d-kDjrS6FkD1+iDBoF0-uz_d_FxwhO2wTP2Lg@mail.gmail.com>
References: <CAG1y0sdzOXhWowTiBomc6CDEVGJdpJy983P5suQfFC_-NmnYtQ@mail.gmail.com>
	<20120410114623.GA24057@suse.de>
	<CAG1y0seZqb+KkSA8Ae0cSfoGWCfBFnPotCM3FUs4q9fND5XjXw@mail.gmail.com>
	<20120410143557.GC5850@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Arvin Schnell <aschnell@suse.de>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: "Matthias G. Eckermann" <mge@suse.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120410143557.GC5850@suse.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 10, 2012 at 9:35 PM, Matthias G. Eckermann <mge@suse.com> wrote:
> On 2012-04-10 T 20:48 +0700 Fajar A. Nugraha wrote:
>> How can I create config for /data or other directories (other than
>> manually creating the config file and .snapshots directory)?
>
> This should do it:
>
> sudo snapper -c home create-config /home
> sudo snapper -c data create-config /data
>
> The reasons for the extra "-c <name>" is that you have to
> tell snapper, which name to choose for the configuration
> you want to create. This name is the one you can reference
> in future actions such as create/modify/delete.

Great! That works, thanks.

Is there an oposite of create-config, i.e. delete for just one subvolume?
delete-config seems to delete everything (configs for all subvolume
and all snapshots).

Also, one minor detail, I noticed that the cron configuration file is
/etc/sysconfig/snapper. It should be /etc/default/snapper in
ubuntu/debian.

-- 
Fajar
