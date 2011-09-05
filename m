From: Elric Milon <whirm@gmx.com>
Subject: Re: Rename BTRfs to MuchSlowerFS ?
Date: Mon, 5 Sep 2011 19:10:21 +0200
Message-ID: <201109051910.21912.whirm@gmx.com>
References: <4E64D3D5.7020407@petaramesh.org> <20110905140023.GP9907@carfax.org.uk> <20110905202000.4c539297@natsu>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
To: "linux-btrfs" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110905202000.4c539297@natsu>
List-ID: <linux-btrfs.vger.kernel.org>

On Monday 05 September 2011 16:20:00 Roman Mamedov wrote:
[...]
> real	0m6.924s
> user	0m0.000s
> sys	0m0.464s
> 
> To be fair, this was on the 2.6.39.2 kernel, and the performance seems to
> be somewhat better on 3.0 (though I didn't do tests like this one or any
> significant dpkg operations on it yet).

Same here with 3.1-rc4 in my Debian SID amd64 laptop with Vertex II SSD disk.

`--> time sync ; time sync; time sync; time sync;time sync ; time sync; time 
sync; time sync;time sync ; time sync; time sync; time sync
sync  0.00s user 0.09s system 3% cpu 2.509 total
sync  0.00s user 0.09s system 3% cpu 2.690 total
sync  0.00s user 0.09s system 4% cpu 2.219 total
sync  0.00s user 0.09s system 3% cpu 2.270 total
sync  0.00s user 0.08s system 3% cpu 2.120 total
sync  0.00s user 0.09s system 4% cpu 2.170 total
sync  0.00s user 0.09s system 4% cpu 2.120 total
sync  0.00s user 0.09s system 3% cpu 2.189 total
sync  0.00s user 0.08s system 3% cpu 2.341 total
sync  0.00s user 0.09s system 3% cpu 2.262 total
sync  0.00s user 0.10s system 2% cpu 3.967 total
sync  0.00s user 0.09s system 4% cpu 2.271 total

-- 

Elric Milon
