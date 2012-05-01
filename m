From: Tomasz Torcz <tomek@pipebreaker.pl>
Subject: Re: [PATCH v2 0/5] Allow for quick removing of btrfs signature from
 block device
Date: Tue, 1 May 2012 14:43:37 +0200
Message-ID: <20120501124337.GA21063@mother.jarsat.pl>
References: <1335875886-12087-1-git-send-email-kario@wit.edu.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1335875886-12087-1-git-send-email-kario@wit.edu.pl>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 01, 2012 at 02:38:01PM +0200, Hubert Kario wrote:
> This patch series adds `btrfs device zero super <dev>` command to rem=
ove the
> btrfs signature from the device as well as fix few minor problems in
> btrfs_prepare_device function.

  Shouldn't you rather extend =E2=80=9Cwipefs=E2=80=9D from util-linux?

--=20
Tomasz Torcz                                                       72->=
|   80->|
xmpp: zdzichubg@chrome.pl                                          72->=
|   80->|

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
